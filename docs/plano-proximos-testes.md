# Plano de proximos testes

Este plano prepara a proxima etapa de diagnostico seguro. Os testes abaixo nao foram executados agora.

## Etapa 1: teste em idle

Objetivo: observar temperaturas, clocks, P-state, consumo e uso de CPU/GPU com o sistema parado por alguns minutos.

Registrar:

- Plano de energia ativo.
- Modo termico atual.
- Temperatura da GPU.
- Consumo atual.
- Clocks atuais.
- P-state.

## Etapa 2: teste com carregador original conectado

Objetivo: confirmar se o comportamento muda com o carregador original conectado e bateria em condicao normal.

Registrar:

- Se o carregador original esta conectado.
- Plano de energia ativo.
- Temperatura.
- Consumo.
- Clocks.
- Sinais de limitacao.

## Etapa 3: teste em modo Performance/Ultra Performance

Objetivo: comparar o comportamento em modo de performance, quando esse modo estiver disponivel em ferramenta Dell/Alienware.

Registrar antes e depois:

- Modo termico selecionado.
- Temperatura.
- Consumo.
- Clocks.
- Ruido/atividade de ventoinhas, de forma descritiva.

## Etapa 4: teste leve de GPU com monitoramento

Objetivo: aplicar uma carga leve e controlada na GPU apenas para observar resposta termica e energetica.

Durante o teste, monitorar:

- Temperatura da GPU.
- Consumo da GPU.
- Limite de potencia.
- Clocks de grafico e memoria.
- P-state.

Interromper se houver temperatura anormal, queda brusca persistente de clocks ou comportamento instavel.

## Etapa 5: comparar se ha limitacao ao movimentar o notebook

Objetivo: verificar se existe diferenca perceptivel quando o notebook permanece parado versus quando e movimentado levemente.

Comparar:

- Clocks.
- P-state.
- Consumo.
- Temperatura.
- Evento de queda de desempenho.

Nao aplicar overclock, undervolt ou tuning durante estes testes.
