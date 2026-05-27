# Energia e performance

Este arquivo documenta os fatores de energia que precisam ser entendidos antes de qualquer ajuste de performance.

## Pontos observados

- Plano de energia ativo no Windows.
- Lista de planos de energia disponiveis.
- Estado do carregador durante testes futuros.
- Modo termico selecionado em ferramentas Dell/Alienware, quando aplicavel.
- Limites reportados pela GPU NVIDIA via `nvidia-smi`, quando disponivel.

## Cuidados

Nao alterar planos, servicos, registro, BIOS ou drivers durante o diagnostico inicial. A primeira etapa e apenas observar o comportamento atual da maquina.

## Relacao com throttling

Quedas de clock ou desempenho podem estar relacionadas a:

- Temperatura.
- Limite de potencia.
- Perfil de energia.
- Politicas Dell/Alienware.
- Intel Dynamic Tuning.
- Sensores de movimento ou postura do notebook.
