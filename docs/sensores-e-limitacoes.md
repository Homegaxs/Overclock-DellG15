# Sensores e limitacoes

Este arquivo descreve recursos que podem limitar desempenho no Dell G15 5530 sem que isso seja necessariamente um problema de overclock.

## Intel Integrated Sensor Solution

O Intel Integrated Sensor Solution pode expor sensores usados pelo sistema para detectar movimento, orientacao, postura ou outros sinais fisicos do notebook. Esses dados podem ser usados por firmware, Windows ou softwares do fabricante para ajustar comportamento termico e energetico.

No diagnostico inicial, a meta e apenas confirmar se o componente esta presente. Nenhum driver e alterado.

## Intel Dynamic Tuning

O Intel Dynamic Tuning pode aplicar politicas dinamicas de energia e temperatura para equilibrar desempenho, consumo e seguranca termica. Em notebooks, isso pode influenciar limites de CPU, resposta das ventoinhas e comportamento sob carga.

No diagnostico inicial, a meta e apenas identificar presenca e versao quando possivel. Nenhum servico, driver ou configuracao e modificado.

## Dell / Alienware Command Center

Ferramentas Dell e Alienware podem controlar perfis termicos, curvas de ventoinha, modos de performance e integracao com firmware. A presenca desses componentes e relevante porque o modo selecionado pode mudar clocks, limites de potencia e resposta termica.

Nenhum perfil e alterado nesta etapa.

## Modos termicos

Modos como Quiet, Balanced, Performance ou Ultra Performance podem mudar o comportamento da maquina. A nomenclatura exata depende da versao do software Dell/Alienware instalado.

Os proximos testes devem registrar o modo usado, mas nao devem alternar perfis sem anotar a condicao inicial e o objetivo do teste.

## Possivel limitacao ao movimentar o notebook

Alguns notebooks podem reduzir desempenho quando detectam movimento, mudanca de postura, instabilidade fisica ou condicoes que indiquem risco termico/eletrico. Por isso, um teste futuro deve comparar a maquina parada com a maquina sendo movimentada levemente, sempre com monitoramento.

Nenhuma conclusao deve ser tomada sem comparar temperatura, energia, clocks e P-state.

## Estado atual

Nenhuma alteracao foi aplicada ainda:

- Sem overclock.
- Sem undervolt.
- Sem alteracao de BIOS.
- Sem alteracao de registro.
- Sem desinstalacao de drivers.
- Sem alteracao de servicos.
