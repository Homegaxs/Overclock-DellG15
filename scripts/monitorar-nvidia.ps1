[CmdletBinding()]
param(
    [int]$DurationSeconds = 120,
    [int]$IntervalSeconds = 1,
    [ValidateSet("parado", "carga-leve", "movimento", "custom")]
    [string]$Teste = "parado",
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($DurationSeconds -lt 1) {
    throw "DurationSeconds deve ser maior que zero."
}

if ($IntervalSeconds -lt 1) {
    throw "IntervalSeconds deve ser maior que zero."
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$LogDir = Join-Path $RepoRoot "logs"
$null = New-Item -ItemType Directory -Force -Path $LogDir

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $OutputPath = Join-Path $LogDir "gpu-monitor-$stamp-$Teste.csv"
}

$nvidiaSmi = Get-Command "nvidia-smi.exe" -ErrorAction SilentlyContinue
if ($null -eq $nvidiaSmi) {
    $nvidiaSmi = Get-Command "nvidia-smi" -ErrorAction SilentlyContinue
}

if ($null -eq $nvidiaSmi) {
    throw "nvidia-smi nao foi encontrado no PATH."
}

function Invoke-NvidiaSmiQuery {
    param(
        [string]$CommandPath
    )

    $query = "temperature.gpu,power.draw,clocks.current.graphics,clocks.current.memory,pstate,utilization.gpu"

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $CommandPath
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
        $message = $standardError.Trim()
        if ([string]::IsNullOrWhiteSpace($message)) {
            $message = "nvidia-smi retornou erro."
        }
        throw $message
    }

    $line = @($standardOutput -split "\r?\n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -First 1)
    if ($line.Count -eq 0) {
        throw "nvidia-smi nao retornou dados da GPU."
    }

    return $line[0]
}

function Format-CsvValue {
    param(
        [AllowNull()]
        [object]$Value
    )

    if ($null -eq $Value) {
        return '""'
    }

    $text = [string]$Value
    $text = $text -replace '"', '""'
    return '"' + $text + '"'
}

$encoding = New-Object System.Text.UTF8Encoding $false
$writer = New-Object System.IO.StreamWriter($OutputPath, $false, $encoding)

try {
    $writer.WriteLine("timestamp,temperature_gpu_c,power_draw_w,clocks_graphics_mhz,clocks_memory_mhz,pstate,utilization_gpu_percent")

    $startedAt = Get-Date
    $endAt = $startedAt.AddSeconds($DurationSeconds)

    while ((Get-Date) -lt $endAt) {
        $timestamp = Get-Date -Format "o"
        $line = Invoke-NvidiaSmiQuery -CommandPath $nvidiaSmi.Source
        $parts = $line -split "\s*,\s*"

        if ($parts.Count -lt 6) {
            throw "Linha inesperada do nvidia-smi: $line"
        }

        $row = @(
            $timestamp,
            $parts[0],
            $parts[1],
            $parts[2],
            $parts[3],
            $parts[4],
            $parts[5]
        ) | ForEach-Object { Format-CsvValue $_ }

        $writer.WriteLine(($row -join ","))
        $writer.Flush()

        Start-Sleep -Seconds $IntervalSeconds
    }
}
finally {
    $writer.Dispose()
}

$relativePath = Resolve-Path -Path $OutputPath -Relative
Write-Host "Monitoramento salvo localmente em $relativePath"
