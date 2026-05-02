# Mapa de Riscos – Projeto OneClinic

## Contexto do Projeto
O projeto OneClinic consiste em uma aplicação web voltada à gestão de clínicas de estética, contemplando funcionalidades como cadastro de pacientes, controle de profissionais, agendamento de consultas, autenticação e prontuário digital.

O gerenciamento de riscos segue as diretrizes do PMBOK 8, considerando tanto ameaças (riscos negativos) quanto oportunidades (riscos positivos), com definição de responsáveis (Risk Owners).

---

## 1. Estrutura Analítica de Riscos (EAR)

Os riscos foram organizados nas seguintes categorias:

- **Técnicos:** arquitetura, código, disponibilidade e integrações
- **Operacionais:** uso do sistema no dia a dia da clínica
- **Privacidade e Cidadania:** proteção de dados sensíveis e conformidade legal
- **Externos/Mercado:** comunidade, concorrência e parcerias
- **Comerciais/Jurídicos:** retorno financeiro e conformidade normativa

---

## 2. Mapa de Riscos

### 2.1 Riscos Críticos e de Alto Impacto

| ID | Categoria | Descrição | Tipo | Impacto | Estratégia de Resposta | Dono do Risco |
|----|----------|----------|------|--------|----------------------|---------------|
| 01 | Privacidade | Vazamento de imagens e dados sensíveis de pacientes | Ameaça | Crítico | Mitigar com criptografia e controle de acesso | DevSecOps |
| 02 | Técnico | Indisponibilidade do sistema durante atendimentos | Ameaça | Alto | Mitigar com redundância e monitoramento | DevOps |
| 06 | Jurídico | Não conformidade com LGPD | Ameaça | Crítico | Evitar com validação jurídica | Jurídico |
| 08 | Operacional | Conflito de horários na agenda | Ameaça | Alto | Mitigar com validações e testes | Backend |

---

### 2.2 Riscos Operacionais

| ID | Categoria | Descrição | Tipo | Impacto | Estratégia | Dono |
|----|----------|----------|------|--------|-----------|------|
| 04 | Operacional | Resistência ao uso do sistema | Ameaça | Alto | Treinamentos e melhorias de UX | UX / Sucesso do Cliente |
| 09 | Operacional | Erros no cadastro de pacientes | Ameaça | Médio | Validação de formulários | Frontend |
| 10 | Técnico | Inconsistência entre profissional e agenda | Ameaça | Médio | Testes de integração | Backend |

---

### 2.3 Riscos Técnicos

| ID | Categoria | Descrição | Tipo | Impacto | Estratégia | Dono |
|----|----------|----------|------|--------|-----------|------|
| 11 | Técnico | Falhas na autenticação | Ameaça | Alto | Middleware e testes | Backend |
| 12 | Técnico | Bugs em produção | Ameaça | Médio | Testes automatizados | Dev Team |
| 13 | Infraestrutura | Falha no banco de dados | Ameaça | Alto | Backup e replicação | DevOps |

---

### 2.4 Oportunidades

| ID | Categoria | Descrição | Tipo | Impacto | Estratégia | Dono |
|----|----------|----------|------|--------|-----------|------|
| 03 | Mercado | Contribuições da comunidade | Oportunidade | Médio | Criar guia de contribuição | Product Manager |
| 05 | Comercial | Automação de lembretes | Oportunidade | Alto | Priorizar desenvolvimento | Tech Lead |
| 14 | Produto | Uso de dados para analytics | Oportunidade | Médio | Implementar dashboards | Product |
| 15 | UX | Agenda inteligente | Oportunidade | Alto | Sugestões automáticas | Dev Team |

---

## 3. Reservas Financeiras

- **Reserva de Contingência:** utilizada para riscos identificados, sob controle do gerente do projeto  
- **Reserva Gerencial:** utilizada para riscos não previstos, sob controle do patrocinador  

---

## 4. Monitoramento de Riscos

O acompanhamento dos riscos será contínuo:

- Revisão ao final de cada sprint  
- Registro centralizado no repositório de documentação  
- Vinculação com issues do projeto  
- Uso de métricas (falhas, downtime, bugs)

---

## 5. Governança de Riscos

Cada risco possui um responsável (Risk Owner), encarregado de:

- Monitorar continuamente o risco  
- Executar ações de resposta  
- Reportar mudanças no nível de impacto  

Papéis envolvidos:

- DevSecOps → segurança  
- DevOps → infraestrutura  
- Backend / Frontend → desenvolvimento  
- Product Manager → priorização  
- Jurídico → conformidade  

---

## 6. Considerações Finais

O gerenciamento de riscos no OneClinic é contínuo e integrado ao desenvolvimento do sistema, garantindo:

- Segurança de dados sensíveis  
- Confiabilidade operacional  
- Adoção pelos usuários  
- Evolução sustentável do produto  

A aplicação das práticas do PMBOK 8 permite uma abordagem estruturada e adaptativa, alinhada às necessidades do projeto e da comunidade atendida.
