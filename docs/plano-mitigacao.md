# Plano de mitigacao

Este plano organiza caminhos seguros para lidar com a queda de desempenho ao movimentar o Dell G15 5530. Nenhuma acao abaixo foi executada automaticamente.

## Principios

- Evitar qualquer mudanca destrutiva.
- Registrar antes/depois em Markdown, sem publicar logs crus.
- Preferir caminhos oficiais e reversiveis.
- Nao alterar BIOS, drivers, servicos, registro ou dispositivos sem autorizacao explicita.

## Caminho A - Oficial e conservador

Objetivo: reduzir a chance de Laptop Mode/limitacao por movimento sem alterar componentes do sistema.

Procedimento recomendado:

1. Usar o notebook fixo, horizontal e em superficie estavel.
2. Manter o carregador original conectado.
3. Selecionar modo Performance ou Ultra Performance no Alienware Command Center, se disponivel.
4. Evitar movimentar o notebook durante jogo ou carga 3D pesada.
5. Se a GPU permanecer limitada depois de movimento, fechar o jogo e reiniciar antes de jogar novamente.
6. Registrar o modo termico usado e repetir o teste de carga real.

Risco: baixo. Este caminho usa apenas operacao normal e controles oficiais do fabricante.

## Caminho B - Validacao controlada

Objetivo: confirmar reprodutibilidade antes de qualquer teste de mitigacao.

Procedimento recomendado:

1. Repetir o RE4 B parado por 2 minutos, garantindo que nao houve movimento acidental.
2. Repetir o RE4 C com 30 segundos parado e 90 segundos de movimento leve.
3. Registrar observacao visual de FPS, stutter, travamento ou queda de fluidez.
4. Se ja existir overlay de FPS disponivel no jogo, Steam, NVIDIA App ou Windows Game Bar, usar sem instalar nada novo.
5. Comparar power draw, clocks, memoria, P-state e uso de GPU.

Criterio de confirmacao:

- RE4 B permanece em P0, com memoria alta e power draw alto.
- RE4 C cai para P-state mais baixo, power draw menor e memoria/clock reduzidos apos movimento.
- Queda visual, se observada, coincide com a queda na telemetria.

Risco: baixo. Este caminho apenas repete monitoramento.

## Caminho C - Teste reversivel do sensor integrado

Objetivo: testar hipotese de sensor/movimento.

Status: executado com autorizacao explicita do usuario em 2026-05-27. Ver detalhes em `docs/teste-sensor-integrado.md`.

Teste manual proposto:

1. Criar um ponto de restauracao do Windows antes de qualquer alteracao.
2. Abrir o Gerenciador de Dispositivos.
3. Localizar `Intel(R) Integrated Sensor Solution`.
4. Desabilitar temporariamente o dispositivo.
5. Repetir RE4 B e RE4 C com o mesmo procedimento.
6. Registrar se a queda por movimento desaparece ou muda.
7. Reabilitar o dispositivo no Gerenciador de Dispositivos ao final do teste.
8. Reiniciar se o Windows ou o Gerenciador de Dispositivos solicitar.

Riscos:

- Pode afetar sensores de movimento, orientacao, postura ou recursos automaticos do notebook.
- Pode alterar comportamento esperado de seguranca/conforto termico.
- Pode afetar recursos que dependem de sensores integrados.
- Pode exigir reinicio para restaurar comportamento normal.

Reversao:

- Reabrir o Gerenciador de Dispositivos.
- Habilitar novamente `Intel(R) Integrated Sensor Solution`.
- Reiniciar o Windows se necessario.
- Conferir se os sensores voltaram ao estado normal.

Importante: este caminho nao altera BIOS, nao altera driver instalado, nao remove dispositivo e nao deve ser feito sem autorizacao explicita.

Resultado do teste executado:

- Com sensor ligado, o movimento no RE4 havia causado queda para P5, power draw medio de 33.34 W no trecho de movimento e memoria media de 1666.38 MHz.
- Com `Intel(R) Integrated Sensor Solution` temporariamente desabilitado, o movimento no RE4 ficou em P0, memoria em 7001 MHz e power draw medio de 79.82 W no trecho de movimento.
- A queda forte desapareceu na telemetria.
- A reversao exigiu reinicio do Windows; apos reiniciar, o dispositivo voltou para `OK` com `CM_PROB_NONE`.

## Registro esperado

Se qualquer caminho for testado no futuro, registrar apenas:

- condicao do teste;
- modo termico;
- app/jogo usado;
- resumo min/media/max da GPU;
- observacao visual de FPS/stutter;
- conclusao;
- se houve reversao.

Nao commitar CSV, LOG, prints ou dados sensiveis.
