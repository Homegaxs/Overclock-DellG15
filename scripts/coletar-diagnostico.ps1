[CmdletBinding()]
param(
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

$RepoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $RepoRoot "docs\diagnostico-inicial.md"
}

$script:Warnings = New-Object System.Collections.Generic.List[string]

function Sanitize-Text {
    param(
        [AllowNull()]
        [object]$Value
    )

    if ($null -eq $Value) {
        return "Nao encontrado"
    }

    $text = ($Value | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($text)) {
        return "Nao encontrado"
    }

    $userProfile = [Environment]::GetFolderPath("UserProfile")
    if (-not [string]::IsNullOrWhiteSpace($userProfile)) {
        $text = [regex]::Replace($text, [regex]::Escape($userProfile), "<caminho-de-usuario-removido>", "IgnoreCase")
    }

    $text = [regex]::Replace($text, "C:\\Users\\[^\\\r\n]+", "<caminho-de-usuario-removido>", "IgnoreCase")
    $text = [regex]::Replace($text, "\b(?:[0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}\b", "<mac-removido>")
    $text = [regex]::Replace($text, "\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", "<email-removido>", "IgnoreCase")
    $text = [regex]::Replace($text, "(?im)(service\s*tag|serial\s*(number)?|numero\s*de\s*serie|s\/n)\s*[:=]\s*\S+", '$1: <removido>')

    return $text
}

function Escape-MarkdownCell {
    param(
        [AllowNull()]
        [object]$Value
    )

    $text = Sanitize-Text $Value
    $text = $text -replace "\r?\n", "<br>"
    $text = $text -replace "\|", "\|"
    return $text
}

function New-MarkdownRow {
    param(
        [object[]]$Fields
    )

    $escaped = $Fields | ForEach-Object { Escape-MarkdownCell $_ }
    return "| " + ($escaped -join " | ") + " |"
}

function Format-BytesAsGiB {
    param(
        [AllowNull()]
        [object]$Bytes
    )

    if ($null -eq $Bytes) {
        return "Nao encontrado"
    }

    try {
        return ("{0:N2} GB" -f ([double]$Bytes / 1GB))
    }
    catch {
        return "Nao encontrado"
    }
}

function Convert-CimDate {
    param(
        [AllowNull()]
        [object]$Value
    )

    if ($null -eq $Value) {
        return "Nao encontrado"
    }

    if ($Value -is [datetime]) {
        return $Value.ToString("yyyy-MM-dd")
    }

    try {
        return ([Management.ManagementDateTimeConverter]::ToDateTime([string]$Value)).ToString("yyyy-MM-dd")
    }
    catch {
        return (Sanitize-Text $Value)
    }
}

function Get-CimSafe {
    param(
        [string]$ClassName
    )

    try {
        return @(Get-CimInstance -ClassName $ClassName -ErrorAction Stop)
    }
    catch {
        $script:Warnings.Add("Falha ao consultar $ClassName.")
        return @()
    }
}

function Get-PowerPlansSafe {
    try {
        return @(Get-CimInstance -Namespace "root\cimv2\power" -ClassName "Win32_PowerPlan" -ErrorAction Stop)
    }
    catch {
        $script:Warnings.Add("Falha ao consultar planos de energia via Win32_PowerPlan.")
        return @()
    }
}

function Invoke-ReadOnlyCommand {
    param(
        [string]$Command,
        [string[]]$Arguments,
        [string]$Label
    )

    try {
        $output = & $Command @Arguments 2>&1
        if ($LASTEXITCODE -ne 0) {
            $script:Warnings.Add("Falha ao executar $Label.")
            return "Nao encontrado"
        }

        return (Sanitize-Text ($output | Out-String))
    }
    catch {
        $script:Warnings.Add("Falha ao executar $Label.")
        return "Nao encontrado"
    }
}

function Get-RegistryValueSafe {
    param(
        [string]$Path
    )

    try {
        return Get-ItemProperty -Path $Path -ErrorAction Stop
    }
    catch {
        $script:Warnings.Add("Falha ao ler $Path.")
        return $null
    }
}

function Get-PropertySafe {
    param(
        [AllowNull()]
        [object]$Object,
        [string]$Name
    )

    if ($null -eq $Object) {
        return $null
    }

    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }

    return $property.Value
}

function Get-NvidiaSmiData {
    $command = Get-Command "nvidia-smi.exe" -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        $command = Get-Command "nvidia-smi" -ErrorAction SilentlyContinue
    }

    if ($null -eq $command) {
        return @{
            Found = $false
            Rows = @()
            Error = "nvidia-smi nao encontrado no PATH."
        }
    }

    $query = "name,driver_version,vbios_version,temperature.gpu,power.limit,power.draw,clocks.current.graphics,clocks.current.memory,pstate"

    try {
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = $command.Source
        $processInfo.Arguments = "--query-gpu=$query --format=csv,noheader,nounits"
        $processInfo.UseShellExecute = $false
        $processInfo.RedirectStandardOutput = $true
        $processInfo.RedirectStandardError = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        [void]$process.Start()
        $standardOutput = $process.StandardOutput.ReadToEnd()
        $standardError = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            return @{
                Found = $true
                Rows = @()
                Error = "nvidia-smi foi encontrado, mas a consulta retornou erro."
            }
        }

        $rows = @()
        foreach ($line in @($standardOutput -split "\r?\n")) {
            $safeLine = Sanitize-Text $line
            if ([string]::IsNullOrWhiteSpace($safeLine) -or $safeLine -eq "Nao encontrado") {
                continue
            }

            $parts = $safeLine -split "\s*,\s*"
            if ($parts.Count -lt 9) {
                continue
            }

            $rows += [pscustomobject]@{
                Name = $parts[0]
                DriverVersion = $parts[1]
                VbiosVersion = $parts[2]
                TemperatureC = $parts[3]
                PowerLimitW = $parts[4]
                PowerDrawW = $parts[5]
                GraphicsClockMHz = $parts[6]
                MemoryClockMHz = $parts[7]
                PState = $parts[8]
            }
        }

        return @{
            Found = $true
            Rows = $rows
            Error = $(if ([string]::IsNullOrWhiteSpace($standardError)) { $null } else { "nvidia-smi retornou dados com aviso em stderr." })
        }
    }
    catch {
        return @{
            Found = $true
            Rows = @()
            Error = "Falha ao executar nvidia-smi."
        }
    }
}

$null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutputPath)

$computerSystem = @(Get-CimSafe "Win32_ComputerSystem") | Select-Object -First 1
$processor = @(Get-CimSafe "Win32_Processor") | Select-Object -First 1
$memoryModules = @(Get-CimSafe "Win32_PhysicalMemory")
$videoControllers = @(Get-CimSafe "Win32_VideoController")
$bios = @(Get-CimSafe "Win32_BIOS") | Select-Object -First 1
$osInfo = Get-RegistryValueSafe "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$pnpDrivers = @(Get-CimSafe "Win32_PnPSignedDriver")
$windowsPowerPlans = @(Get-PowerPlansSafe)
$activePowerPlans = @($windowsPowerPlans | Where-Object { $_.IsActive })

$uninstallPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

$installedApps = @()
foreach ($path in $uninstallPaths) {
    try {
        $installedApps += @(Get-ItemProperty -Path $path -ErrorAction Stop)
    }
    catch {
        $script:Warnings.Add("Falha ao ler lista de programas instalados.")
    }
}

$relevantApps = @(
    $installedApps |
        Where-Object {
            $displayName = Get-PropertySafe $_ "DisplayName"
            $displayName -and ($displayName -match "(?i)dell|alienware|awcc|supportassist|command center|power manager")
        } |
        Sort-Object @{ Expression = { Get-PropertySafe $_ "DisplayName" } }, @{ Expression = { Get-PropertySafe $_ "DisplayVersion" } } -Unique
)

$relevantServices = @(
    Get-Service |
        Where-Object {
            $_.Name -match "(?i)dell|alienware|awcc|supportassist|dynamic|dptf|sensor" -or
            $_.DisplayName -match "(?i)dell|alienware|awcc|supportassist|dynamic|dptf|sensor"
        } |
        Sort-Object DisplayName
)

$sensorAndTuningDrivers = @(
    $pnpDrivers |
        Where-Object {
            $friendlyName = if ($_.PSObject.Properties["FriendlyName"]) { $_.FriendlyName } else { "" }
            $_.DeviceName -match "(?i)integrated sensor|sensor solution|dynamic tuning|dptf" -or
            $friendlyName -match "(?i)integrated sensor|sensor solution|dynamic tuning|dptf"
        } |
        Sort-Object DeviceName, DriverVersion -Unique
)

$nvidiaDrivers = @(
    $pnpDrivers |
        Where-Object {
            $friendlyName = if ($_.PSObject.Properties["FriendlyName"]) { $_.FriendlyName } else { "" }
            $_.DeviceName -match "(?i)nvidia|geforce" -or
            $friendlyName -match "(?i)nvidia|geforce"
        } |
        Sort-Object DeviceName, DriverVersion -Unique
)

$nvidiaSmi = Get-NvidiaSmiData

$lines = New-Object System.Collections.Generic.List[string]
$generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$oAcute = [char]0x00F3
$aAcute = [char]0x00E1
$cCedilla = [char]0x00E7
$oTilde = [char]0x00F5
$title = "# Diagn" + $oAcute + "stico inicial - Dell G15 5530"
$summaryHeading = "## Resumo da m" + $aAcute + "quina"
$observationsHeading = "## Observa" + $cCedilla + $oTilde + "es iniciais"
$nextHeading = "## Pr" + $oAcute + "ximos testes recomendados"

$lines.Add($title)
$lines.Add("")
$lines.Add("> Gerado em $generatedAt por ``scripts/coletar-diagnostico.ps1``.")
$lines.Add("> Arquivo preparado para repositorio publico; campos sensiveis conhecidos foram omitidos ou sanitizados.")
$lines.Add("")

$lines.Add($summaryHeading)
$lines.Add("")
$lines.Add((New-MarkdownRow @("Campo", "Valor")))
$lines.Add((New-MarkdownRow @("---", "---")))
$lines.Add((New-MarkdownRow @("Fabricante", $(if ($computerSystem) { $computerSystem.Manufacturer } else { $null }))))
$lines.Add((New-MarkdownRow @("Modelo", $(if ($computerSystem) { $computerSystem.Model } else { $null }))))
$lines.Add((New-MarkdownRow @("CPU", $(if ($processor) { $processor.Name } else { $null }))))
$lines.Add((New-MarkdownRow @("Nucleos / threads", $(if ($processor) { "$($processor.NumberOfCores) / $($processor.NumberOfLogicalProcessors)" } else { $null }))))
$lines.Add((New-MarkdownRow @("RAM total", $(if ($computerSystem) { Format-BytesAsGiB $computerSystem.TotalPhysicalMemory } else { $null }))))
$lines.Add((New-MarkdownRow @("GPUs detectadas", $(if ($videoControllers.Count -gt 0) { ($videoControllers | ForEach-Object { $_.Name }) -join "; " } else { $null }))))
$lines.Add("")

$lines.Add("## Windows")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Campo", "Valor")))
$lines.Add((New-MarkdownRow @("---", "---")))
if ($osInfo) {
    $lines.Add((New-MarkdownRow @("Produto", $osInfo.ProductName)))
    $lines.Add((New-MarkdownRow @("Edicao", $osInfo.EditionID)))
    $lines.Add((New-MarkdownRow @("Versao de exibicao", $osInfo.DisplayVersion)))
    $lines.Add((New-MarkdownRow @("Build", "$($osInfo.CurrentBuild).$($osInfo.UBR)")))
}
else {
    $lines.Add((New-MarkdownRow @("Produto", $null)))
}
$lines.Add((New-MarkdownRow @("Arquitetura", $env:PROCESSOR_ARCHITECTURE)))
$lines.Add("")

$lines.Add("## CPU")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Campo", "Valor")))
$lines.Add((New-MarkdownRow @("---", "---")))
$lines.Add((New-MarkdownRow @("Nome", $(if ($processor) { $processor.Name } else { $null }))))
$lines.Add((New-MarkdownRow @("Nucleos", $(if ($processor) { $processor.NumberOfCores } else { $null }))))
$lines.Add((New-MarkdownRow @("Threads", $(if ($processor) { $processor.NumberOfLogicalProcessors } else { $null }))))
$lines.Add((New-MarkdownRow @("Clock maximo reportado", $(if ($processor) { "$($processor.MaxClockSpeed) MHz" } else { $null }))))
$lines.Add("")

$lines.Add("## RAM")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Modulo", "Capacidade", "Velocidade declarada", "Velocidade configurada")))
$lines.Add((New-MarkdownRow @("---", "---", "---", "---")))
if ($memoryModules.Count -gt 0) {
    $index = 1
    foreach ($module in $memoryModules) {
        $lines.Add((New-MarkdownRow @(
            "Modulo $index",
            (Format-BytesAsGiB $module.Capacity),
            $(if ($module.Speed) { "$($module.Speed) MT/s" } else { $null }),
            $(if ($module.ConfiguredClockSpeed) { "$($module.ConfiguredClockSpeed) MT/s" } else { $null })
        )))
        $index++
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")

$lines.Add("## GPU")
$lines.Add("")
$lines.Add((New-MarkdownRow @("GPU", "Driver", "Status")))
$lines.Add((New-MarkdownRow @("---", "---", "---")))
if ($videoControllers.Count -gt 0) {
    foreach ($gpu in $videoControllers) {
        $lines.Add((New-MarkdownRow @($gpu.Name, $gpu.DriverVersion, $gpu.Status)))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")

$lines.Add("## BIOS")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Campo", "Valor")))
$lines.Add((New-MarkdownRow @("---", "---")))
$lines.Add((New-MarkdownRow @("Fabricante", $(if ($bios) { $bios.Manufacturer } else { $null }))))
$lines.Add((New-MarkdownRow @("Versao", $(if ($bios) { $bios.SMBIOSBIOSVersion } else { $null }))))
$lines.Add((New-MarkdownRow @("Data", $(if ($bios) { Convert-CimDate $bios.ReleaseDate } else { $null }))))
$lines.Add("")

$lines.Add("## Energia")
$lines.Add("")
$lines.Add("Plano ativo:")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Nome", "Ativo", "Identificador")))
$lines.Add((New-MarkdownRow @("---", "---", "---")))
if ($activePowerPlans.Count -gt 0) {
    foreach ($plan in $activePowerPlans) {
        $lines.Add((New-MarkdownRow @($plan.ElementName, $plan.IsActive, $plan.InstanceID)))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")
$lines.Add("Planos disponiveis:")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Nome", "Ativo", "Identificador")))
$lines.Add((New-MarkdownRow @("---", "---", "---")))
if ($windowsPowerPlans.Count -gt 0) {
    foreach ($plan in $windowsPowerPlans) {
        $lines.Add((New-MarkdownRow @($plan.ElementName, $plan.IsActive, $plan.InstanceID)))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")

$lines.Add("## NVIDIA")
$lines.Add("")
if ($nvidiaDrivers.Count -gt 0) {
    $lines.Add("Drivers NVIDIA detectados pelo Windows:")
    $lines.Add("")
    $lines.Add((New-MarkdownRow @("Dispositivo", "Versao do driver", "Fornecedor")))
    $lines.Add((New-MarkdownRow @("---", "---", "---")))
    foreach ($driver in $nvidiaDrivers) {
        $lines.Add((New-MarkdownRow @($driver.DeviceName, $driver.DriverVersion, $driver.Manufacturer)))
    }
    $lines.Add("")
}

if ($nvidiaSmi.Found -and $nvidiaSmi.Rows.Count -gt 0) {
    $lines.Add('Dados do `nvidia-smi`:')
    $lines.Add("")
    $lines.Add((New-MarkdownRow @("GPU", "Driver", "VBIOS", "Temp.", "Limite W", "Uso W", "Clock grafico", "Clock memoria", "P-state")))
    $lines.Add((New-MarkdownRow @("---", "---", "---", "---", "---", "---", "---", "---", "---")))
    foreach ($row in $nvidiaSmi.Rows) {
        $lines.Add((New-MarkdownRow @(
            $row.Name,
            $row.DriverVersion,
            $row.VbiosVersion,
            "$($row.TemperatureC) C",
            "$($row.PowerLimitW) W",
            "$($row.PowerDrawW) W",
            "$($row.GraphicsClockMHz) MHz",
            "$($row.MemoryClockMHz) MHz",
            $row.PState
        )))
    }
}
else {
    $message = if ($nvidiaSmi.Error) { $nvidiaSmi.Error } else { "Dados do nvidia-smi nao encontrados." }
    $lines.Add("- $(Sanitize-Text $message)")
}
$lines.Add("")

$lines.Add("## Dell / Alienware")
$lines.Add("")
$lines.Add("Softwares relevantes detectados:")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Nome", "Versao", "Fornecedor")))
$lines.Add((New-MarkdownRow @("---", "---", "---")))
if ($relevantApps.Count -gt 0) {
    foreach ($app in $relevantApps) {
        $lines.Add((New-MarkdownRow @(
            (Get-PropertySafe $app "DisplayName"),
            (Get-PropertySafe $app "DisplayVersion"),
            (Get-PropertySafe $app "Publisher")
        )))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")
$lines.Add("Servicos relevantes detectados:")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Servico", "Nome de exibicao", "Status", "Inicializacao")))
$lines.Add((New-MarkdownRow @("---", "---", "---", "---")))
if ($relevantServices.Count -gt 0) {
    foreach ($service in $relevantServices) {
        $lines.Add((New-MarkdownRow @($service.Name, $service.DisplayName, $service.Status, $service.StartType)))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")

$lines.Add("## Sensores e recursos que podem limitar desempenho")
$lines.Add("")
$lines.Add((New-MarkdownRow @("Recurso", "Dispositivo/driver", "Versao", "Fornecedor")))
$lines.Add((New-MarkdownRow @("---", "---", "---", "---")))
if ($sensorAndTuningDrivers.Count -gt 0) {
    foreach ($driver in $sensorAndTuningDrivers) {
        $resource = if ($driver.DeviceName -match "(?i)integrated sensor|sensor solution") {
            "Intel Integrated Sensor Solution"
        }
        elseif ($driver.DeviceName -match "(?i)dynamic tuning|dptf") {
            "Intel Dynamic Tuning"
        }
        else {
            "Sensor/tuning"
        }

        $lines.Add((New-MarkdownRow @($resource, $driver.DeviceName, $driver.DriverVersion, $driver.Manufacturer)))
    }
}
else {
    $lines.Add((New-MarkdownRow @("Nao encontrado", "Nao encontrado", "Nao encontrado", "Nao encontrado")))
}
$lines.Add("")
$lines.Add("Esses componentes podem influenciar limites termicos, energia, sensores de movimento e perfis de desempenho. Nenhuma alteracao foi aplicada por este script.")
$lines.Add("")

$lines.Add($observationsHeading)
$lines.Add("")
$lines.Add("- Diagnostico de leitura executado sem aplicar overclock, undervolt ou tuning.")
$lines.Add("- Nenhuma alteracao de BIOS, registro, drivers ou servicos foi aplicada.")
$lines.Add("- O arquivo foi gerado para repo publico e evita serial, service tag, IP, MAC, usuario Windows e caminhos pessoais.")
if ($script:Warnings.Count -gt 0) {
    foreach ($warning in ($script:Warnings | Sort-Object -Unique)) {
        $lines.Add("- Aviso: $(Sanitize-Text $warning)")
    }
}
$lines.Add("")

$lines.Add($nextHeading)
$lines.Add("")
$lines.Add("- Etapa 1: teste em idle.")
$lines.Add("- Etapa 2: teste com carregador original conectado.")
$lines.Add("- Etapa 3: teste em modo Performance/Ultra Performance.")
$lines.Add("- Etapa 4: teste leve de GPU com monitoramento.")
$lines.Add("- Etapa 5: comparar se ha limitacao ao movimentar o notebook.")
$lines.Add("")
$lines.Add('Ver detalhes em `docs/plano-proximos-testes.md`.')
$lines.Add("")

$content = Sanitize-Text ($lines -join "`n")
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($OutputPath, $content, $utf8NoBom)

Write-Host "Diagnostico salvo em docs/diagnostico-inicial.md"
