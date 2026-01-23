# Projeto AWS Terraform — Infraestrutura Cloud

Este projeto implementa uma **infraestrutura cloud completa na AWS**, utilizando **Terraform**, com foco em boas práticas de **segurança**, **observabilidade**, **automação** e **separação de ambientes**.

O objetivo é simular um **cenário real de produção**, indo além de tutoriais básicos, cobrindo desde o deploy até monitoramento e pipeline CI/CD.

---

## 🎯 Visão Geral

A aplicação é um sistema simples de cadastro:

* **Frontend** servido via **NGINX**
* **Backend** em **Node.js**, acessado via proxy do NGINX
* **Persistência** em **DynamoDB**

Toda a aplicação roda em instâncias **EC2**, atrás de um **Application Load Balancer**, com **Auto Scaling Group**, logs centralizados e alarmes configurados.

---

## 🏗️ Arquitetura

Fluxo de acesso:

```
Usuário → ALB → EC2 (NGINX → Backend Node.js) → DynamoDB
```

Componentes principais:

* **ALB (Application Load Balancer)**: ponto único de entrada da aplicação
* **Target Group**: define os destinos saudáveis
* **Auto Scaling Group (ASG)**: gerencia o ciclo de vida das EC2
* **EC2**: executa containers Docker da aplicação
* **Docker Hub**: repositório das imagens
* **DynamoDB**: armazenamento dos dados

As instâncias **não são acessíveis diretamente pela internet**.

---

## 🔐 Segurança

* A aplicação é acessada **exclusivamente via ALB**
* As EC2 **não possuem portas abertas publicamente**
* Dois Security Groups são utilizados:

  * SG do ALB: permite tráfego HTTP público
  * SG das EC2: aceita tráfego **somente** do SG do ALB
* Permissões AWS são gerenciadas via **IAM Role**, sem uso de credenciais hardcoded

---

## 🌍 Ambientes (dev / prod)

O projeto suporta múltiplos ambientes usando:

* variável `environment`
* arquivos `tfvars`

Exemplo:

```bash
terraform apply -var-file=dev.tfvars
terraform apply -var-file=prod.tfvars
```

Benefícios:

* isolamento total entre ambientes
* nomes de recursos separados
* logs e alarmes independentes
* redução de risco em produção

Atualmente:

* **dev**: utilizado para testes
* **prod**: definido no código, mas não aplicado

---

## 🚀 Deploy e Automação

### Local

```bash
terraform init
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

### CI/CD (GitHub Actions)

* **terraform plan** roda automaticamente
* **terraform apply** é manual
* o ambiente é escolhido no momento do deploy

Isso evita mudanças acidentais em produção.

---

## 📊 Observabilidade

### Logs (CloudWatch)

* cloud-init
* syslog
* docker
* aplicação

Cada ambiente possui seus próprios Log Groups.

### Alarmes

* CPU utilization do ASG
* Unhealthy targets no ALB

Os alarmes ajudam a detectar falhas reais sem excesso de ruído.

---

## 🧠 Decisões Técnicas

* **Auto Scaling Group** mesmo com uma instância:

  * segue padrão de produção
  * permite escalar sem refatoração
  * possibilita testar health checks e recovery

* **Terraform com backend remoto (S3 + DynamoDB)**:

  * state centralizado
  * lock para evitar corrupção

* **Separação por tfvars**:

  * evita duplicação de código
  * reduz drift entre ambientes

---

## 🛠️ O que foi aprendido

* criação de infra AWS do zero com Terraform
* separação de ambientes
* CI/CD aplicado à infraestrutura
* observabilidade básica em produção
* debug de erros reais (lock de state, health check, dependências)

---

## 🔮 Próximos Passos

* remover hardcoded remanescente
* melhorar métricas e alarmes
* implementar HTTPS com domínio e certificados
* escalar aplicação com múltiplas instâncias

---

## 📌 Observação

Este projeto foi desenvolvido com foco em **aprendizado prático**, priorizando decisões que refletem ambientes reais, mesmo em um contexto de estudo.
