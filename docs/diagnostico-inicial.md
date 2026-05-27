# Diagnóstico inicial - Dell G15 5530

> Gerado em 2026-05-27 20:29:45 -03:00 por `scripts/coletar-diagnostico.ps1`.
> Arquivo preparado para repositorio publico; campos sensiveis conhecidos foram omitidos ou sanitizados.

## Resumo da máquina

| Campo | Valor |
| --- | --- |
| Fabricante | Dell Inc. |
| Modelo | Dell G15 5530 |
| CPU | 13th Gen Intel(R) Core(TM) i5-13450HX |
| Nucleos / threads | 10 / 16 |
| RAM total | 15,69 GB |
| GPUs detectadas | NVIDIA GeForce RTX 3050 6GB Laptop GPU; Intel(R) UHD Graphics |

## Windows

| Campo | Valor |
| --- | --- |
| Produto | Windows 10 Pro |
| Edicao | Professional |
| Versao de exibicao | 25H2 |
| Build | 26200.8457 |
| Arquitetura | AMD64 |

## CPU

| Campo | Valor |
| --- | --- |
| Nome | 13th Gen Intel(R) Core(TM) i5-13450HX |
| Nucleos | 10 |
| Threads | 16 |
| Clock maximo reportado | 2400 MHz |

## RAM

| Modulo | Capacidade | Velocidade declarada | Velocidade configurada |
| --- | --- | --- | --- |
| Modulo 1 | 8,00 GB | 4800 MT/s | 4800 MT/s |
| Modulo 2 | 8,00 GB | 4800 MT/s | 4800 MT/s |

## GPU

| GPU | Driver | Status |
| --- | --- | --- |
| NVIDIA GeForce RTX 3050 6GB Laptop GPU | 32.0.16.1047 | OK |
| Intel(R) UHD Graphics | 32.0.101.7084 | OK |

## BIOS

| Campo | Valor |
| --- | --- |
| Fabricante | Dell Inc. |
| Versao | 1.32.0 |
| Data | 2026-03-31 |

## Energia

Plano ativo:

| Nome | Ativo | Identificador |
| --- | --- | --- |
| Driver Booster Power Plan | True | Microsoft:PowerPlan\{c6b08da9-28e4-4edc-8c73-052631f81b57} |

Planos disponiveis:

| Nome | Ativo | Identificador |
| --- | --- | --- |
| Equilibrado | False | Microsoft:PowerPlan\{381b4222-f694-41f0-9685-ff5bb260df2e} |
| Driver Booster Power Plan | True | Microsoft:PowerPlan\{c6b08da9-28e4-4edc-8c73-052631f81b57} |

## NVIDIA

Drivers NVIDIA detectados pelo Windows:

| Dispositivo | Versao do driver | Fornecedor |
| --- | --- | --- |
| NVIDIA GeForce RTX 3050 6GB Laptop GPU | 32.0.16.1047 | NVIDIA |
| NVIDIA High Definition Audio | 1.4.5.7 | Microsoft |
| NVIDIA Platform Controllers and Framework | 32.0.16.1029 | NVIDIA |
| NVIDIA Virtual Audio Device (Wave Extensible) (WDM) | 4.65.0.12 | Microsoft |

Dados do `nvidia-smi`:

| GPU | Driver | VBIOS | Temp. | Limite W | Uso W | Clock grafico | Clock memoria | P-state |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| NVIDIA GeForce RTX 3050 6GB Laptop GPU | 610.47 | 94.07.82.40.2f | 44 C | [N/A] W | 12.05 W | 1732 MHz | 7001 MHz | P0 |

## Dell / Alienware

Softwares relevantes detectados:

| Nome | Versao | Fornecedor |
| --- | --- | --- |
| Alienware Command Center Package Manager | 6.14.4.0 | Dell Inc. |
| Alienware FX Display Smart Installer (6.14.5.0) | 6.14.5.0 | Dell Inc |
| Alienware FX Display002 | 6.13.6.0 | Dell Inc. |
| AlienwareArena | 1.4.1 | Alienware |
| Dell Connected Service Delivery | 1.1.1.0 | Dell Technologies, Inc. |
| Dell Connected Service Delivery SubAgent | 1.0.0.0 | Dell Technologies, Inc. |
| Dell Core Services | 1.13.23.0 | Dell, Inc. |
| Dell SupportAssist | 5.0.1.2516 | Dell Inc. |
| Dell SupportAssist OS Recovery Plugin for Dell Update | 5.5.16.1 | Dell Inc. |
| Dell SupportAssist Remediation | 5.5.15.2 | Dell Inc. |

Servicos relevantes detectados:

| Servico | Nome de exibicao | Status | Inicializacao |
| --- | --- | --- | --- |
| DellClientManagementService | Dell Client Management Service | Running | Automatic |
| DellConnectedServiceDelivery | Dell Connected Service Delivery | Running | Automatic |
| SupportAssistAgent | Dell SupportAssist | Running | Automatic |
| Dell SupportAssist Remediation | Dell SupportAssist Remediation | Running | Automatic |
| DellTechHub | Dell TechHub | Running | Automatic |
| jhi_service | Intel(R) Dynamic Application Loader Host Interface Service | Running | Automatic |
| dptftcs | Intel(R) Dynamic Tuning Technology Telemetry Service | Running | Automatic |
| SensorDataService | Serviço de Dados de Sensor | Stopped | Manual |
| SensrSvc | Serviço de Monitoramento de Sensor | Stopped | Manual |
| SensorService | Serviço de Sensor | Stopped | Manual |

## Sensores e recursos que podem limitar desempenho

| Recurso | Dispositivo/driver | Versao | Fornecedor |
| --- | --- | --- | --- |
| Intel Dynamic Tuning | Intel(R) Dynamic Tuning Technology | 9.1.10009.1745 | Intel |
| Intel Dynamic Tuning | Intel(R) Dynamic Tuning Technology Updater Component | 9.1.10009.1745 | Intel |
| Intel Integrated Sensor Solution | Intel(R) Integrated Sensor Solution | 3.1.0.4596 | Intel |

Esses componentes podem influenciar limites termicos, energia, sensores de movimento e perfis de desempenho. Nenhuma alteracao foi aplicada por este script.

## Observações iniciais

- Diagnostico de leitura executado sem aplicar overclock, undervolt ou tuning.
- Nenhuma alteracao de BIOS, registro, drivers ou servicos foi aplicada.
- O arquivo foi gerado para repo publico e evita serial, service tag, IP, MAC, usuario Windows e caminhos pessoais.

## Próximos testes recomendados

- Etapa 1: teste em idle.
- Etapa 2: teste com carregador original conectado.
- Etapa 3: teste em modo Performance/Ultra Performance.
- Etapa 4: teste leve de GPU com monitoramento.
- Etapa 5: comparar se ha limitacao ao movimentar o notebook.

Ver detalhes em `docs/plano-proximos-testes.md`.