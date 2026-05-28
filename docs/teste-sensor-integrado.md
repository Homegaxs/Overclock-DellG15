# Teste reversivel do sensor integrado

Data do teste: 2026-05-27.

## Objetivo

Verificar se desabilitar temporariamente o `Intel(R) Integrated Sensor Solution` impede a queda de desempenho ao movimentar o Dell G15 5530 durante carga real de GPU.

## Regras do teste

- Teste reversivel.
- Sem overclock.
- Sem undervolt.
- Sem alteracao de BIOS.
- Sem alteracao de driver.
- Sem desinstalar dispositivo.
- Sem remover driver.
- Sem alterar registro do Windows.
- Sem mexer em Intel Dynamic Tuning.
- Sem desabilitar servicos Dell.
- Sem publicar CSV, LOG, print ou dados sensiveis.

## Estado inicial

Consulta de leitura por nome exato:

| Dispositivo | Status inicial | Classe | Presente |
| --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | OK | System | True |

O identificador interno do dispositivo foi usado apenas localmente para acao reversivel e nao foi publicado.

## Ponto de restauracao

Criado com sucesso antes da alteracao.

## Acao reversivel

O dispositivo `Intel(R) Integrated Sensor Solution` foi desabilitado temporariamente.

Resultado apos desabilitar:

| Dispositivo | Status apos desabilitar | Classe | Presente | Reinicio |
| --- | --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | Error | System | True | Nao solicitado |

## Testes com Resident Evil 4

Resident Evil 4 foi usado via Steam, com carga real na GPU NVIDIA.

O script atual aceita apenas os rotulos `parado`, `carga-leve`, `movimento` e `custom`; por isso os testes foram executados com `-Teste custom` e `-OutputPath` nomeando os CSVs locais como `re4-sensor-off-*`.

### Sensor desabilitado - parado

| Condicao | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RE4 parado, sensor desabilitado | 113 | 78 / 82.24 / 86 C | 92.29 / 94.71 / 94.99 W | 1897 / 1911.24 / 1972 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.95 / 99% | P0 (113/113) |

### Sensor desabilitado - movimento

| Condicao | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RE4 movimento, sensor desabilitado | 113 | 82 / 82.79 / 86 C | 79.51 / 81.28 / 95.23 W | 1762 / 1816.52 / 1950 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.95 / 100% | P0 (113/113) |

Recorte do teste com movimento:

| Segmento | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0-30 s parado | 29 | 83 / 84.03 / 86 C | 79.51 / 85.51 / 95.23 W | 1762 / 1833.10 / 1950 MHz | 7001 / 7001 / 7001 MHz | 99 / 99.10 / 100% | P0 (29/29) |
| 30-120 s movimento | 84 | 82 / 82.36 / 83 C | 79.55 / 79.82 / 80.08 W | 1785 / 1810.80 / 1875 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.89 / 100% | P0 (84/84) |

Observacao visual de FPS/stutter/travamento nao foi registrada diretamente por Codex; a conclusao abaixo se baseia na telemetria.

## Reversao

O comando de reabilitacao foi executado ao final dos testes. Antes do reinicio, a leitura ainda retornou:

| Dispositivo | Status apos tentativa de reabilitar | Problema | Presente |
| --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | Error | CM_PROB_FAILED_ADD | True |

Tambem foram tentados reinicio do dispositivo via `pnputil` e varredura de hardware, sem publicar identificadores do dispositivo. O status continuou em erro.

Apos reiniciar o Windows, a reversao foi confirmada:

| Dispositivo | Status apos reinicio | Problema | Presente |
| --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | OK | CM_PROB_NONE | True |

Reinicio necessario: sim.

## Conclusao

Comparacao com sensor habilitado:

- RE4 B parado com sensor ligado: P0 em 108/108 amostras, power medio 93.08 W, memoria 7001 MHz.
- RE4 C movimento com sensor ligado: P5 em 73/85 amostras no trecho 30-120 s, power medio 33.34 W, memoria media 1666.38 MHz e memoria minima 810 MHz.
- RE4 movimento com sensor desabilitado: P0 em 84/84 amostras no trecho 30-120 s, power medio 79.82 W, memoria 7001 MHz.

Conclusao: com o sensor integrado temporariamente desabilitado, a queda forte para P5 nao apareceu na telemetria. A memoria permaneceu em 7001 MHz e o P-state permaneceu P0 durante o movimento.

O sensor foi reabilitado e voltou para OK apos reinicio do Windows.
