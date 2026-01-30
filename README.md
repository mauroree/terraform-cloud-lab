## 📌 Projeto Cloud/DevOps na AWS

## Resumo

Este projeto implementa uma infraestrutura na AWS utilizando **Terraform** para simular um ambiente real de produção, com foco em **automação**, **alta disponibilidade**, **segurança**, **escalabilidade horizontal** e **boas práticas de arquitetura em nuvem**.

O objetivo principal não é demonstrar complexidade excessiva, mas sim **tomadas de decisão arquiteturais conscientes**, alinhadas ao AWS Well-Architected Framework e ao cenário de um time Cloud/DevOps.

---

## Visão Geral da Arquitetura

A arquitetura foi desenhada para ser **stateless**, **elástica** e **resiliente a falhas**, utilizando serviços gerenciados sempre que possível.

Componentes principais:

* VPC com subnets públicas em múltiplas Zonas de Disponibilidade
* Application Load Balancer (ALB)
* Auto Scaling Group (ASG) com instâncias EC2
* Aplicação containerizada com Docker
* DynamoDB para persistência de dados
* CloudWatch para logs, métricas e alarmes
* CI/CD com GitHub Actions
* Infraestrutura como Código com Terraform

Fluxo de tráfego:

Usuário → ALB → Auto Scaling Group (EC2) → DynamoDB

As instâncias EC2 são tratadas como **descartáveis e stateless**, podendo ser substituídas automaticamente sem impacto no serviço.

---

## Infraestrutura como Código (Terraform)

Toda a infraestrutura é provisionada utilizando Terraform, garantindo:

* Reprodutibilidade
* Versionamento
* Automação
* Padronização entre ambientes

O projeto suporta múltiplos ambientes por meio de arquivos `tfvars`, permitindo separar configurações de forma clara e controlada.

O estado do Terraform é armazenado remotamente em um bucket S3, com criptografia habilitada.

---

## Computação e Escalabilidade

* As instâncias EC2 são gerenciadas por um Auto Scaling Group
* A quantidade mínima, máxima e desejada de instâncias é configurável
* O sistema pode escalar horizontalmente conforme a demanda

Mesmo quando configurado com apenas uma instância ativa, o uso de ASG garante:

* Recuperação automática em caso de falha
* Substituição transparente de instâncias
* Base sólida para crescimento futuro

---

## Segurança

A segurança foi tratada como parte do design da arquitetura:

* Uso de **IAM Roles** para acesso a serviços da AWS
* Princípio do **menor privilégio** aplicado às permissões
* Nenhuma credencial sensível hardcoded na aplicação
* Acesso ao DynamoDB realizado exclusivamente via IAM Role
* Security Groups controlando o tráfego de rede
* Isolamento lógico por meio da VPC

Não há acesso SSH às instâncias EC2. A administração ocorre via automação, logs e observabilidade.

---

## Persistência de Dados

* DynamoDB utilizado como banco de dados NoSQL totalmente gerenciado
* Alta disponibilidade e escalabilidade nativa
* Modelo adequado para workloads stateless e orientados a API

Essa escolha reduz a carga operacional e elimina a necessidade de gerenciar servidores de banco de dados.

---

## Observabilidade

A observabilidade do sistema é feita com:

* CloudWatch Logs para logs da aplicação
* CloudWatch Metrics para métricas de infraestrutura
* CloudWatch Alarms para detecção de falhas

Esses mecanismos permitem monitorar a saúde do sistema e reagir rapidamente a incidentes.

---

## CI/CD

O pipeline de CI/CD é implementado com GitHub Actions:

* `terraform plan` executado automaticamente
* `terraform apply` realizado manualmente, de forma controlada
* Smoke tests após o deploy

Essa abordagem prioriza segurança e previsibilidade, evitando alterações não intencionais em produção.

---

## Well-Architected Framework

O projeto foi concebido considerando os pilares do AWS Well-Architected Framework:

* **Excelência Operacional**: automação, IaC e observabilidade
* **Segurança**: IAM Roles, menor privilégio e isolamento de rede
* **Confiabilidade**: ALB, Auto Scaling Group e múltiplas AZs
* **Eficiência de Desempenho**: arquitetura stateless e escalável
* **Otimização de Custos**: recursos sob demanda e escalonamento automático
* **Sustentabilidade**: evitar overprovisioning e desperdício de recursos

As decisões arquiteturais foram tomadas com base em trade-offs claros e justificáveis.

---

## Limitações Conhecidas

Alguns pontos foram conscientemente deixados fora do escopo inicial:

* HTTPS com ACM (ausência de domínio próprio)
* CDN para conteúdo estático
* Cache em memória

Essas limitações são escolhas intencionais e não impedem a evolução da arquitetura.

---

## Próximos Passos

Possíveis evoluções do projeto incluem:

* Frontend estático em S3 com CloudFront
* HTTPS com certificados ACM
* Dashboards mais detalhados no CloudWatch
* Configuração de Budgets e alertas de custo
* Refinamento de políticas IAM

---

## Objetivo do Projeto

Este projeto tem caráter educacional e demonstrativo, com foco em:

* Consolidação de conceitos de Cloud e DevOps
* Aplicação prática de boas práticas de arquitetura
* Preparação para ambientes reais de produção

Ele foi desenvolvido para servir como **base técnica e arquitetural**, e não como um produto final.
