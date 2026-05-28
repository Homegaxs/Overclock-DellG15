# Overclock-DellG15

Repositorio publico para estudar com seguranca o comportamento de um Dell G15 5530 antes de qualquer overclock, undervolt ou tuning.

O foco inicial e diagnostico: entender hardware, Windows, drivers, BIOS, VBIOS, energia, temperaturas, sensores e possiveis sinais de throttling. Qualquer alteracao de performance so deve ser considerada depois que esses pontos estiverem documentados e comparados com testes controlados.

## Estado atual

- Nenhum overclock aplicado.
- Nenhum undervolt aplicado.
- Nenhuma alteracao de BIOS, registro, drivers ou servicos aplicada pelo fluxo deste repositorio.
- Dados sensiveis devem ser omitidos antes de qualquer commit.

## Diagnostico inicial

O script de coleta gera um Markdown sanitizado em `docs/diagnostico-inicial.md`.

Execute no PowerShell, a partir da raiz do repositorio:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/coletar-diagnostico.ps1
```

O script coleta apenas informacoes de leitura, como versao do Windows, modelo, CPU, RAM, GPU, BIOS sem serial/service tag, planos de energia, softwares e servicos Dell/Alienware relevantes, Intel Integrated Sensor Solution, Intel Dynamic Tuning e dados basicos do `nvidia-smi` quando disponivel.

## Teste movimento vs parado

O fluxo de teste compara o notebook parado com movimento fisico leve, usando apenas monitoramento por `nvidia-smi`. Ele nao altera overclock, undervolt, BIOS, drivers, servicos, Intel Integrated Sensor Solution ou Intel Dynamic Tuning.

Para registrar 2 minutos de telemetria local da GPU:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/monitorar-nvidia.ps1 -DurationSeconds 120 -Teste parado
```

Os CSVs sao salvos em `logs/` e ignorados pelo Git. Publique apenas resumos em `docs/resultados-testes.md`.

## Cuidados para repo publico

Nao publicar:

- Service Tag ou serial number.
- IP ou MAC address.
- Nome completo do usuario do Windows.
- Caminhos pessoais do perfil do Windows.
- Logs crus grandes.
- Prints com dados pessoais.
- Tokens, e-mails privados ou credenciais.

## Documentacao

- [Diagnostico inicial](docs/diagnostico-inicial.md)
- [Hardware](docs/hardware.md)
- [Drivers e BIOS](docs/drivers-e-bios.md)
- [Energia e performance](docs/energia-e-performance.md)
- [Sensores e limitacoes](docs/sensores-e-limitacoes.md)
- [Plano de proximos testes](docs/plano-proximos-testes.md)
- [Teste movimento vs parado](docs/teste-movimento-vs-parado.md)
- [Resultados dos testes](docs/resultados-testes.md)
- [Analise de Laptop Mode](docs/analise-laptop-mode.md)
- [Plano de mitigacao](docs/plano-mitigacao.md)
