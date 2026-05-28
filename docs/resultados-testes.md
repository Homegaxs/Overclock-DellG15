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
