# Teste com carga real da GPU

O teste anterior usou Notepad em branco como aplicacao leve. Ele foi util para validar o script de monitoramento, mas e inconclusivo para carga real de GPU porque nao gera renderizacao 3D relevante.

Este teste repete a comparacao parado versus movimento usando uma aplicacao que realmente acione GPU, sem instalar ferramentas novas e sem alterar configuracoes do sistema.

## Regras mantidas

- Nao aplicar overclock.
- Nao aplicar undervolt.
- Nao alterar BIOS.
- Nao alterar drivers.
- Nao alterar servicos.
- Nao desabilitar Intel Integrated Sensor Solution.
- Nao desabilitar Intel Dynamic Tuning.
- Nao publicar CSV, LOG, print ou dados sensiveis.

## Aplicacao usada

- Aplicacao: Resident Evil 4 via Steam.
- Motivo: jogo ja instalado, mais pesado que o teste anterior com Notepad e capaz de gerar carga real na GPU NVIDIA.
- Configuracao: cena/tela atual do jogo mantida fixa; resolucao e preset grafico nao foram registrados.

## Procedimento

1. Abrir a aplicacao 3D escolhida.
2. Manter uma cena fixa, menu 3D ou gameplay controlado.
3. Rodar tres coletas de 2 minutos com `scripts/monitorar-nvidia.ps1`.
4. Teste A: carga real com notebook parado.
5. Teste B: mesma carga real com notebook parado, para confirmar consistencia.
6. Teste C: mesma carga real, primeiros 30 segundos parado e depois movimento leve por 90 segundos.
7. Observar manualmente queda de FPS, stutter, travamento ou queda de fluidez.
8. Analisar CSVs localmente e registrar apenas resumo em `docs/resultados-testes.md`.

## Interpretacao

O teste com Resident Evil 4 mostrou uma queda clara na telemetria durante o Teste C, logo apos o trecho inicial parado.

Resumo:

- O Teste A teve aquecimento/transicao inicial e carga menos consistente.
- O Teste B foi a melhor referencia parada: GPU em P0 durante todas as amostras, uso medio de 97.87%, power draw medio de 93.08 W e memoria em 7001 MHz.
- No Teste C, os primeiros 30 segundos parados ficaram em P0, memoria em 7001 MHz e power draw medio de 81.86 W.
- Apos o inicio da janela de movimento, a primeira queda apareceu por volta de 32.1 s.
- No trecho de 30-120 s do Teste C, o P-state predominante virou P5, o power draw medio caiu para 33.34 W, a memoria media caiu para 1666.38 MHz e o clock grafico minimo chegou a 585 MHz.

Conclusao:

- O movimento coincidiu com queda clara de power draw, memoria, clock grafico e P-state.
- A queda apareceu na telemetria.
- A percepcao visual de FPS/stutter nao foi registrada diretamente nesta execucao, entao a conclusao visual ainda depende de repeticao com observacao humana ou overlay de FPS.
- Para telemetria de GPU, o teste nao foi inconclusivo: houve queda forte no Teste C em comparacao com a referencia parada.
