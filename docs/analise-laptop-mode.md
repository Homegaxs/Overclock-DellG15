# Analise de Laptop Mode

Este documento resume a evidencia coletada ate agora sobre queda de desempenho ao movimentar o Dell G15 5530. Nenhuma correcao foi aplicada ainda.

## Resumo dos testes

Foram feitos testes com monitoramento via `nvidia-smi`, salvando CSVs apenas localmente em `logs/` e publicando somente resumos em Markdown.

O teste inicial com Notepad em branco foi util para validar o script, mas nao gerou carga real de GPU. Depois disso, foi executado um teste com Resident Evil 4 via Steam, mantendo uma cena/tela fixa.

## Comparacao principal

Referencia parada: Teste RE4 B.

- GPU em P0 durante todas as amostras.
- Power draw medio: 93.08 W.
- Clock grafico medio: 1929.84 MHz.
- Clock de memoria: 7001 MHz em todas as amostras.
- Uso medio de GPU: 97.87%.

Teste com movimento: Teste RE4 C, principalmente o trecho de 30-120 s.

- A queda iniciou por volta de 32.1 s, logo apos a janela inicial parada.
- Power draw medio no trecho 30-120 s: 33.34 W.
- Clock grafico minimo: 585 MHz.
- Clock de memoria medio no trecho 30-120 s: 1666.38 MHz.
- Clock de memoria minimo: 810 MHz.
- P-state predominante no trecho 30-120 s: P5 em 73/85 amostras.
- Uso medio de GPU continuou alto: 99.34%.

## O que P0 e P5 indicam

Em alto nivel, P-states indicam estados de performance/energia da GPU NVIDIA.

- P0: estado de alta performance, esperado em carga 3D pesada quando a GPU esta autorizada a consumir mais energia.
- P5: estado de menor performance/energia, normalmente associado a clocks e consumo reduzidos.

No teste parado, a GPU permaneceu em P0. No teste com movimento, ela passou majoritariamente para P5 depois do inicio da janela de movimento.

## Por que parece limitacao de politica/energia

A queda nao parece falta de carga, porque a utilizacao media da GPU continuou alta no trecho de movimento. O comportamento observado foi:

- uso de GPU alto;
- power draw muito menor;
- clock de memoria muito menor;
- queda de P0 para P5;
- reducao de clocks logo apos o inicio da janela de movimento.

Esse conjunto sugere que a GPU ainda estava sendo demandada, mas algum limite de energia/performance foi aplicado.

## Relacao provavel com Laptop Mode e sensores

O comportamento e compativel com acionamento de politica de notebook durante movimento. No contexto do Dell G15 5530, isso pode envolver:

- Laptop Mode documentado pela Dell para limitar GPU quando movimento e detectado;
- sensores de movimento/orientacao expostos pelo Intel Integrated Sensor Solution;
- politicas termicas/energeticas de firmware, Dell/Alienware Command Center ou Dell Dynamic Tuning;
- Intel Dynamic Tuning ajustando limites conforme contexto termico/energia/postura.

Ainda nao foi isolado qual componente aplica o limite. O teste apenas mostra que a queda coincide com movimento e aparece claramente na telemetria da GPU.

## Estado atual

Nenhuma correcao foi aplicada:

- Sem overclock.
- Sem undervolt.
- Sem alteracao de BIOS.
- Sem alteracao de drivers.
- Sem alteracao de servicos.
- Sem desabilitar dispositivos.
- Sem alteracao de registro do Windows.

Os proximos passos devem priorizar validacao controlada e caminhos reversiveis.
