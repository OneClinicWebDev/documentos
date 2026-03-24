# Modelo C4 — Arquitetura do Sistema OneClinic

Este documento apresenta a modelagem arquitetural do sistema **OneClinic** utilizando o **Modelo C4**.

O C4 Model organiza a arquitetura de software em diferentes níveis de abstração, permitindo compreender o sistema desde uma visão geral até seus componentes internos.

Os níveis utilizados neste documento são:

- C1 — System Context Diagram
- C2 — Container Diagram
- C3 — Component Diagram
- C4 — Deployment Diagram

---

# C1 — System Context Diagram

O **Diagrama de Contexto** apresenta o sistema OneClinic como uma única unidade e mostra sua interação com usuários e sistemas externos.

## Atores do Sistema

**Administrador / Dono**
- Gerencia usuários
- Configura o sistema
- Acompanha relatórios e métricas

**Recepcionista / Secretária**
- Realiza cadastro de pacientes
- Agenda consultas
- Gerencia atendimentos

**Profissional**
- Consulta sua agenda
- Visualiza histórico de atendimentos

O **paciente não acessa diretamente o sistema**, sendo atendido e gerenciado pela recepção.

## Sistemas Externos

O sistema integra-se com os seguintes serviços externos:

**Serviço de Email**
- Envio de notificações e confirmações

**Google Calendar**
- Sincronização da agenda de profissionais

**WhatsApp API**
- Envio de lembretes de consulta

## Diagrama

<img width="620" height="426" alt="c1-oneClinic" src="https://github.com/user-attachments/assets/c58f1c9b-9819-4102-9804-6515b26b207f" />


---

# C2 — Container Diagram

O **Diagrama de Containers** apresenta os principais blocos de execução do sistema.

O sistema OneClinic segue uma **arquitetura monolítica**, porém separada em camadas bem definidas entre frontend, backend e banco de dados.

## Containers

### Frontend Web

Tecnologias:

- Vue.js
- TailwindCSS

Responsabilidades:

- Interface do usuário
- Comunicação com API
- Exibição de dados e formulários

---

### Backend API

Tecnologia:

- Django

Responsabilidades:

- Regras de negócio
- Autenticação
- Controle de acesso
- Integrações externas
- Gerenciamento de dados

---

### Banco de Dados

Tecnologia:

- PostgreSQL

Responsabilidades:

- Persistência de dados
- Armazenamento de pacientes
- Agendamentos
- usuários e permissões

---

## Diagrama

<img width="934" height="728" alt="c2-oneClinic" src="https://github.com/user-attachments/assets/0528220b-291a-47f1-8251-93eda1e35f39" />

---

# C3 — Component Diagram

O **Diagrama de Componentes** detalha a estrutura interna do backend Django.

A arquitetura segue um padrão organizado em módulos responsáveis por diferentes áreas do sistema.

## Componentes Principais

### Auth Module

Responsável por:

- Autenticação de usuários
- Login
- Controle de permissões

O sistema utiliza:

- **Argon2**
- **Salt**
- **Pepper**

para garantir segurança no armazenamento de senhas.

---

### Patient Module

Responsável por:

- Cadastro de pacientes
- Atualização de dados
- Consulta de histórico

---

### Professional Module

Responsável por:

- Cadastro de profissionais
- Gestão de agenda

---

### Scheduling Module

Responsável por:

- Criação de agendamentos
- Alteração de horários
- Cancelamentos

---

### Notification Module

Responsável por:

- Envio de notificações
- Confirmação de consultas
- Lembretes automáticos

---

### Integration Module

Responsável por integração com serviços externos:

- Google Calendar
- WhatsApp
- Email

---

## Diagrama

<img width="1146" height="530" alt="c3-oneClinic" src="https://github.com/user-attachments/assets/a7191ff1-7991-4122-a856-393bbe06b332" />

---

# C4 — Deployment Diagram

O **Diagrama de Implantação** apresenta como o sistema será distribuído na infraestrutura.

## Infraestrutura Planejada

### Frontend

Hospedagem prevista em:

- Vercel
- ou Hostinger

Responsável por servir a aplicação Vue.js para os usuários.

---

### Backend

Hospedagem prevista em:

- Render

Responsável por executar a aplicação Django e disponibilizar a API.

---

### Banco de Dados

Banco utilizado:

- PostgreSQL

Responsável por armazenar todos os dados do sistema.

---

## Fluxo de comunicação

1. O usuário acessa o sistema via navegador
2. O frontend é carregado pelo serviço de hospedagem
3. O frontend comunica-se com o backend via API
4. O backend processa as regras de negócio
5. Os dados são persistidos no banco PostgreSQL

---

## Diagrama

<img width="271" height="450" alt="C4-oneClinic" src="https://github.com/user-attachments/assets/6ca4c550-2425-4eae-b9db-e9c97001c8e4" />

---

# Conclusão

A arquitetura do sistema OneClinic foi modelada utilizando o **Modelo C4**, permitindo visualizar o sistema em diferentes níveis de abstração.

A arquitetura adotada é **monolítica com separação em camadas**, utilizando tecnologias modernas para frontend e backend.

Principais tecnologias utilizadas:

Frontend:
- Vue.js
- TailwindCSS

Backend:
- Django

Banco de Dados:
- PostgreSQL

A arquitetura também prevê integração com serviços externos como **Google Calendar, Email e WhatsApp**, permitindo automação de notificações e sincronização de agenda.

Essa estrutura garante organização, escalabilidade e facilidade de manutenção do sistema.

---
