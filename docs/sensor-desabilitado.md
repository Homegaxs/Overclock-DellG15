# Sensor integrado desabilitado

Data do teste: 2026-05-27.

## Objetivo

Deixar o `Intel(R) Integrated Sensor Solution` desabilitado por enquanto, por decisao do usuario, e repetir testes com Resident Evil 4 para verificar se a queda de desempenho ao movimentar o Dell G15 5530 desaparece no uso real.

## Motivo da alteracao

Testes anteriores indicaram:

- Com o sensor ligado e RE4 em movimento, a GPU caiu para P5, power medio de 33.34 W no trecho de movimento e memoria media de 1666.38 MHz.
- Com o sensor temporariamente desabilitado, a GPU permaneceu em P0 durante movimento, memoria em 7001 MHz e power medio de 79.82 W no trecho de movimento.

Isso sugere que o sensor integrado participa do acionamento de Laptop Mode ou politica similar durante movimento.

## Riscos

- Pode afetar sensores de movimento, orientacao, postura ou recursos automaticos do notebook.
- Pode alterar comportamento de seguranca/conforto termico ligado a postura/movimento.
- Pode exigir reinicio para voltar ao estado normal.
- Pode afetar recursos do Windows ou Dell/Alienware que dependem de sensores integrados.

## Como reabilitar depois

Opcao pelo Gerenciador de Dispositivos:

1. Abrir o Gerenciador de Dispositivos.
2. Localizar `Intel(R) Integrated Sensor Solution`.
3. Selecionar habilitar dispositivo.
4. Reiniciar o Windows se o status nao voltar para OK imediatamente.

Opcao por PowerShell administrativo:

```powershell
$d = Get-PnpDevice -FriendlyName "Intel(R) Integrated Sensor Solution"
Enable-PnpDevice -InstanceId $d.InstanceId -Confirm:$false
```

Se o status permanecer em erro, reiniciar o Windows e conferir novamente.

## Estado antes

Consulta de leitura por nome exato:

| Dispositivo | Status antes | Problema | Presente |
| --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | OK | CM_PROB_NONE | True |

O identificador interno do dispositivo foi usado apenas localmente e nao foi publicado.

## Ponto de restauracao

Criado com sucesso antes da alteracao.

## Estado depois

O dispositivo foi desabilitado com sucesso e ficou nesse estado por decisao do usuario.

| Dispositivo | Status depois | Problema | Presente | Reinicio |
| --- | --- | --- | --- | --- |
| Intel(R) Integrated Sensor Solution | Error | CM_PROB_DISABLED | True | Nao necessario |

## Testes com Resident Evil 4

Resident Evil 4 foi usado via Steam, em carga real de GPU. A cena/tela foi mantida fixa tanto quanto possivel.

Observacao visual de FPS/stutter/travamento nao foi registrada diretamente por Codex; a conclusao se baseia na telemetria coletada por `nvidia-smi`.

### Teste A - parado

| Condicao | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RE4 parado, sensor desabilitado | 114 | 78 / 81.14 / 84 C | 88.82 / 94.16 / 95.53 W | 1897 / 1925.86 / 1980 MHz | 7001 / 7001 / 7001 MHz | 92 / 98.18 / 100% | P0 (114/114) |

### Teste B - movimento

| Condicao | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| RE4 movimento, sensor desabilitado | 114 | 82 / 84.45 / 86 C | 79.47 / 91.82 / 94.83 W | 1785 / 1894.61 / 1957 MHz | 7001 / 7001 / 7001 MHz | 86 / 98.60 / 100% | P0 (114/114) |

Recorte do teste com movimento:

| Segmento | Amostras | Temp. GPU min/media/max | Power draw min/media/max | Clock grafico min/media/max | Clock memoria min/media/max | Uso GPU min/media/max | P-state predominante |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0-30 s parado | 29 | 84 / 84.03 / 85 C | 93.64 / 94.41 / 94.78 W | 1897 / 1909.83 / 1957 MHz | 7001 / 7001 / 7001 MHz | 97 / 98.90 / 100% | P0 (29/29) |
| 30-120 s movimento | 85 | 82 / 84.59 / 86 C | 79.47 / 90.94 / 94.83 W | 1785 / 1889.42 / 1950 MHz | 7001 / 7001 / 7001 MHz | 86 / 98.49 / 100% | P0 (85/85) |

## Conclusao

Comparacao com testes anteriores:

- Sensor ligado + movimento: P5 em 73/85 amostras no trecho 30-120 s, power medio 33.34 W, memoria media 1666.38 MHz.
- Sensor temporariamente desligado + movimento: P0 em 84/84 amostras no trecho 30-120 s, power medio 79.82 W, memoria 7001 MHz.
- Sensor agora desabilitado + movimento: P0 em 85/85 amostras no trecho 30-120 s, power medio 90.94 W, memoria 7001 MHz.

Conclusao:

- Melhorou em relacao ao sensor ligado.
- Ficou igual ou melhor que o teste temporario anterior na telemetria de movimento.
- Nao houve queda para P5.
- Nao houve queda de memoria para 810 MHz/1666 MHz.
- A GPU permaneceu em P0 durante todo o movimento.
- Nenhum problema colateral foi observado pelos comandos usados neste teste.

Estado final: o sensor permanece desabilitado por enquanto, por decisao do usuario.
