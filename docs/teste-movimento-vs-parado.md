# Teste movimento vs parado

Objetivo: comparar o comportamento do Dell G15 5530 parado versus movimentado levemente, sem aplicar overclock, undervolt, alteracao de BIOS, drivers, servicos, Intel Integrated Sensor Solution ou Intel Dynamic Tuning.

Este teste prepara a Etapa 1 em idle e a Etapa 5 de comparacao com movimento. Ele registra apenas telemetria basica da GPU via `nvidia-smi` em arquivos locais ignorados pelo Git.

## Cuidados

- Nao alterar modo de BIOS.
- Nao alterar drivers.
- Nao alterar servicos.
- Nao desabilitar Intel Integrated Sensor Solution.
- Nao desabilitar Intel Dynamic Tuning.
- Nao publicar arquivos `.csv` ou `.log` gerados em `logs/`.
- Nao tirar prints com dados pessoais.
- Registrar no repositorio apenas conclusoes resumidas em `docs/resultados-testes.md`.

## Preparacao

1. Fechar janelas com dados pessoais.
2. Confirmar que o notebook esta em uma superficie estavel e ventilada.
3. Anotar manualmente o plano de energia e o modo termico atual, sem alterar nada.
4. Abrir um PowerShell na raiz do repositorio.
5. Confirmar que `nvidia-smi` esta disponivel:

```powershell
nvidia-smi
```

## Monitoramento

O script abaixo grava uma amostra por segundo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/monitorar-nvidia.ps1 -DurationSeconds 120 -Teste parado
```

Campos gravados no CSV local:

- `timestamp`
- `temperature_gpu_c`
- `power_draw_w`
- `clocks_graphics_mhz`
- `clocks_memory_mhz`
- `pstate`
- `utilization_gpu_percent`

## Teste A: notebook parado por 2 minutos

Objetivo: medir a base em idle.

Passos:

1. Deixar o notebook parado.
2. Fechar apps pesados.
3. Rodar:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/monitorar-nvidia.ps1 -DurationSeconds 120 -Teste parado
```

4. Nao tocar no notebook durante os 2 minutos.
5. Anotar em `docs/resultados-testes.md` temperatura, clocks, consumo, P-state e se houve travamento.

## Teste B: app ou jogo leve parado

Objetivo: observar uma carga leve mantendo o notebook fisicamente parado.

Passos:

1. Abrir um app ou jogo leve.
2. Manter a mesma cena, menu, mapa ou tela por todo o teste.
3. Rodar:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/monitorar-nvidia.ps1 -DurationSeconds 120 -Teste carga-leve
```

4. Manter o notebook parado.
5. Registrar manualmente se houve queda de FPS, travamento, stutter ou queda visual de fluidez.

## Teste C: movimentar levemente o notebook

Objetivo: comparar a mesma carga do Teste B com movimento fisico leve.

Passos:

1. Manter aberto o mesmo app ou jogo leve usado no Teste B.
2. Rodar:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/monitorar-nvidia.ps1 -DurationSeconds 120 -Teste movimento
```

3. Nos primeiros 30 segundos, manter o notebook parado.
4. Depois, movimentar levemente o notebook, sem impactos e sem bloquear entradas ou saidas de ar.
5. Observar se ocorre queda de FPS, travamento, stutter, queda de clocks, mudanca de P-state ou queda de consumo.
6. Registrar manualmente em `docs/resultados-testes.md` se a queda aconteceu e em qual momento aproximado.

## Como comparar

Comparar Teste B e Teste C:

- Se os clocks caem durante movimento.
- Se o consumo cai durante movimento.
- Se o P-state muda durante movimento.
- Se a utilizacao da GPU cai sem motivo aparente.
- Se a queda visual de FPS coincide com queda de clocks, consumo ou P-state.

Os CSVs ficam apenas em `logs/` e nao devem ser commitados.
