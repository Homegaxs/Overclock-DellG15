# Resultados dos testes

Resumo dos testes executados. Nao colar logs crus, CSV completo, prints ou dados pessoais.

| Data | Teste | Condicao | Duracao | Plano de energia | Modo termico | FPS/travamento observado | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | P-state predominante | Observacoes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-05-27 | A | Idle, notebook parado, carregador conectado | 2 min | Driver Booster Power Plan | Nao alterado / nao registrado | Nao observado diretamente | 41 / 41.89 / 42 C | 11.48 / 11.70 / 12.28 W | 1732 / 1732 / 1732 MHz | P0 (114/114) | 114 amostras. Sem queda de clock ou mudanca de P-state na telemetria. |
| 2026-05-27 | B | Notepad em branco, notebook parado, carregador conectado | 2 min | Driver Booster Power Plan | Nao alterado / nao registrado | Nao observado diretamente | 42 / 42.98 / 43 C | 11.63 / 11.92 / 12.37 W | 1732 / 1732 / 1732 MHz | P0 (114/114) | 114 amostras. App leve usado apenas para manter uma tela constante. |
| 2026-05-27 | C | Mesmo app leve do Teste B; primeiros 30 s parado e depois janela de movimento leve | 2 min | Driver Booster Power Plan | Nao alterado / nao registrado | Sem queda indicada pela telemetria; percepcao visual nao registrada | 42 / 43.25 / 44 C | 11.63 / 11.93 / 12.29 W | 1732 / 1732 / 1732 MHz | P0 (114/114) | 114 amostras. Sem reducao de clock grafico, sem mudanca de P-state e sem queda de power draw apos 30 s. |

## Comparacao Teste B vs Teste C

- Temperatura media: Teste B 42.98 C; Teste C 43.25 C; diferenca aproximada de +0.27 C no Teste C.
- Power draw medio: Teste B 11.92 W; Teste C 11.93 W; diferenca aproximada de +0.01 W no Teste C.
- Clock grafico: 1732 MHz em min/media/max nos dois testes.
- Clock de memoria: 7001 MHz em min/media/max nos dois testes.
- P-state: P0 em todas as amostras dos dois testes.
- Utilizacao media da GPU: Teste B 1.88%; Teste C 2.32%; diferenca aproximada de +0.44 ponto percentual no Teste C.
- Queda perceptivel no Teste C: nao confirmada visualmente no registro desta execucao; pela telemetria, nao houve queda clara.
- Momento aproximado da queda: nao aplicavel, pois nao houve queda detectada na telemetria.

## Recorte do Teste C

| Segmento | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Utilizacao GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- |
| 0-30 s | 29 | 43 / 43.00 / 43 C | 11.63 / 11.83 / 12.20 W | 1732 / 1732 / 1732 MHz | 0 / 1.55 / 8% | P0 (29/29) |
| 30-120 s | 85 | 42 / 43.34 / 44 C | 11.65 / 11.96 / 12.29 W | 1732 / 1732 / 1732 MHz | 0 / 2.58 / 8% | P0 (85/85) |

## Observacoes gerais

- Nenhuma alteracao de overclock, undervolt, BIOS, drivers ou servicos deve ser aplicada durante estes testes.
- Se houver queda de FPS ou travamento, registrar o momento aproximado e comparar com clocks, consumo, P-state e utilizacao da GPU.
- Manter os arquivos gerados em `logs/` fora do commit.
- Arquivos CSV analisados localmente e nao incluidos no commit.

## Teste com carga real

O teste anterior com Notepad em branco foi util para validar o monitoramento, mas foi inconclusivo para carga real. Este novo teste usou Resident Evil 4 via Steam, com uma cena/tela do jogo mantida fixa. Resolucao e preset grafico nao foram registrados.

| Data | Teste | App/jogo | Condicao | Duracao | FPS/stutter observado | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante | Observacoes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-05-27 | RE4 A | Resident Evil 4 | Carga real, notebook parado | 2 min | Nao observado diretamente | 59 / 72.74 / 81 C | 14.01 / 69.78 / 99.20 W | 1732 / 1909.55 / 2062 MHz | 7001 / 7001 / 7001 MHz | 0 / 70.63 / 99% | P0 (111/111) | Execucao com aquecimento/transicao inicial; menos consistente que o Teste B. |
| 2026-05-27 | RE4 B | Resident Evil 4 | Mesma carga real, notebook parado | 2 min | Nao observado diretamente | 75 / 83.52 / 86 C | 79.94 / 93.08 / 97.07 W | 1867 / 1929.84 / 1972 MHz | 7001 / 7001 / 7001 MHz | 59 / 97.87 / 100% | P0 (108/108) | Melhor referencia parada: alta utilizacao, power draw estavel e memoria fixa em 7001 MHz. |
| 2026-05-27 | RE4 C | Resident Evil 4 | Mesma carga real; 30 s parado e depois movimento leve | 2 min | Queda visual nao registrada diretamente; queda forte na telemetria | 63 / 71.71 / 86 C | 19.20 / 45.69 / 95.26 W | 585 / 1755.29 / 1980 MHz | 810 / 3023.43 / 7001 MHz | 80 / 99.23 / 100% | P5 (73/114) | Queda iniciou por volta de 32.1 s, logo apos a janela de movimento. |

### Comparacao parado vs movimento com RE4

- Referencia parada principal: Teste RE4 B.
- Movimento: Teste RE4 C, especialmente o trecho de 30-120 s.
- Power draw medio: 93.08 W no RE4 B; 33.34 W no trecho 30-120 s do RE4 C.
- Clock grafico medio: 1929.84 MHz no RE4 B; 1722.47 MHz no trecho 30-120 s do RE4 C.
- Clock grafico minimo: 1867 MHz no RE4 B; 585 MHz no RE4 C.
- Clock de memoria medio: 7001 MHz no RE4 B; 1666.38 MHz no trecho 30-120 s do RE4 C.
- Clock de memoria minimo: 7001 MHz no RE4 B; 810 MHz no RE4 C.
- P-state: P0 em 108/108 amostras no RE4 B; P5 em 73/85 amostras no trecho 30-120 s do RE4 C.
- Uso medio de GPU: 97.87% no RE4 B; 99.34% no trecho 30-120 s do RE4 C.
- Queda no movimento: sim, clara na telemetria.
- Momento aproximado da queda: 32.1 s apos inicio do Teste C.

### Recorte do Teste C com RE4

| Segmento | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0-30 s parado | 29 | 83 / 83.48 / 86 C | 79.54 / 81.86 / 93.68 W | 1792 / 1851.48 / 1950 MHz | 7001 / 7001 / 7001 MHz | 98 / 98.90 / 100% | P0 (29/29) |
| 30-120 s movimento | 85 | 63 / 67.69 / 83 C | 19.20 / 33.34 / 95.26 W | 585 / 1722.47 / 1980 MHz | 810 / 1666.38 / 7001 MHz | 80 / 99.34 / 100% | P5 (73/85) |

Interpretacao: a utilizacao da GPU continuou alta, mas o estado de performance, memoria, power draw e clocks cairam depois do inicio do movimento. Isso sugere limitacao por politica/sensor/energia durante movimento, mas ainda nao identifica a causa exata. Nenhuma alteracao foi aplicada.

## Teste com sensor integrado temporariamente desabilitado

O usuario autorizou executar a Opcao C do plano de mitigacao como teste reversivel. O dispositivo identificado por nome exato foi `Intel(R) Integrated Sensor Solution`. Foi criado ponto de restauracao antes da alteracao. Nenhum driver foi removido, nenhum dispositivo foi desinstalado, BIOS/registro/servicos nao foram alterados e Intel Dynamic Tuning nao foi modificado.

| Data | Teste | App/jogo | Condicao | Duracao | FPS/stutter observado | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante | Observacoes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-05-27 | Sensor off parado | Resident Evil 4 | Sensor integrado desabilitado, notebook parado | 2 min | Nao observado diretamente | 78 / 82.24 / 86 C | 92.29 / 94.71 / 94.99 W | 1897 / 1911.24 / 1972 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.95 / 99% | P0 (113/113) | Carga forte e estavel. |
| 2026-05-27 | Sensor off movimento | Resident Evil 4 | Sensor integrado desabilitado; 30 s parado e depois movimento leve | 2 min | Nao observado diretamente | 82 / 82.79 / 86 C | 79.51 / 81.28 / 95.23 W | 1762 / 1816.52 / 1950 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.95 / 100% | P0 (113/113) | Nao houve queda para P5 nem queda de memoria na telemetria. |

### Comparacao sensor ligado vs sensor desabilitado

- Sensor ligado, RE4 B parado: P0 em 108/108, power medio 93.08 W, memoria 7001 MHz.
- Sensor ligado, RE4 C movimento: P5 em 73/85 no trecho 30-120 s, power medio 33.34 W, memoria media 1666.38 MHz.
- Sensor desabilitado, movimento 30-120 s: P0 em 84/84, power medio 79.82 W, memoria 7001 MHz.
- Resultado: a queda forte de P-state/memoria/power draw desapareceu na telemetria com o sensor integrado temporariamente desabilitado.
- Observacao importante: a tentativa de reabilitacao retornou `CM_PROB_FAILED_ADD` antes do reinicio, mas apos reiniciar o Windows o sensor voltou para `OK` com `CM_PROB_NONE`.
