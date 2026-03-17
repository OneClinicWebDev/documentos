# OneClinic — Documento de Visão

> **Versão:** 2.0 (SaaS Enterprise)  
> **Última atualização:** 17 de Março de 2026

---

## 1. Qual é o principal objetivo do sistema?

Prover uma plataforma SaaS (Software as a Service) multitenant para a gestão 360° de clínicas de estética. O sistema visa automatizar processos operacionais, financeiros e de fidelização, garantindo o isolamento total de dados entre diferentes clínicas e oferecendo flexibilidade através de uma engine de configurações dinâmicas.

---

## 2. Quais são as principais funcionalidades?

- **Multitenancy Nativo:** Isolamento completo de dados por clínica através de identificadores únicos (UUID).
- **Engine de Parâmetros:** Configuração dinâmica de status de agenda, métodos de pagamento, níveis de acesso e canais de comunicação via JSONB.
- **Gestão de Fidelização:** Criação e controle de pacotes de sessões, assinaturas recorrentes e sistema de cupons com controle antifraude.
- **Agenda Inteligente:** Controle de disponibilidade com restrição física de conflitos de horário diretamente no banco de dados.
- **Estoque Auditável:** Registro de movimentações (entradas/saídas) com rastreabilidade de responsável e origem.
- **Financeiro Avançado:** Controle de parcelamento, fluxo de caixa, gestão de inadimplência e cálculo automático de valores líquidos/descontos.
- **CRM e Comunicação:** Histórico completo do cliente, controle de crédito acumulado e log de notificações (WhatsApp/E-mail).
- **Auditoria de Sistema:** Log detalhado de alterações (INSERT/UPDATE/DELETE) com armazenamento de estados anteriores e atuais.

---

## 3. Quem vai usar o sistema?

O sistema utiliza controle de acesso baseado em funções (RBAC), cujas permissões são definidas dinamicamente na tabela de parâmetros:

- **Admin (Dono/Gestor):** Acesso total à gestão da clínica, colaboradores, configurações do sistema e relatórios financeiros estratégicos.
- **Secretário(a):** Foco operacional; gerencia a agenda global, cadastros de clientes, recebimentos, fluxo de caixa e estoque.
- **Profissional:** Acesso restrito à própria agenda, execução de atendimentos e registro de consumo de materiais.

---

## 4. O que é necessário cadastrar?

- **Clínica:** Nome, CNPJ (obrigatório para fins fiscais e contratuais SaaS) e configurações de conta.
- **Parâmetros:** Definição de códigos e comportamentos para status, cores de interface e regras de negócio.
- **Colaboradores:** Nome, e-mail (único por clínica), nível de acesso e vínculo com o Supabase Auth.
- **Clientes:** Dados pessoais (CPF único por clínica), contatos e saldo de crédito.
- **Produtos:** Itens de estoque com definição de estoque mínimo para alertas.
- **Planos e Cupons:** Regras de desconto, total de sessões e validade de pacotes.

---

## 5. O que é necessário consultar?

- **Dashboard de Gestão:** Indicadores de receita, ocupação de agenda e saúde do estoque.
- **Assinaturas Ativas:** Saldo de sessões restantes de cada cliente em tempo real.
- **Trilha de Auditoria:** Logs de alterações para segurança e depuração.
- **Inadimplência:** Lista dinâmica de parcelas vencidas e agendamentos não quitados.
- **Conformidade LGPD:** Logs de comunicações enviadas e acessos a dados sensíveis.

---

## 6. O que é necessário editar?

- **Status de Agendamento:** Fluxo dinâmico (Pendente, Confirmado, Concluído, Cancelado).
- **Configurações de Parâmetros:** Alteração de cores e comportamentos de sistema sem necessidade de novo deploy.
- **Saldos de Estoque:** Ajustes realizados via movimentações justificadas.
- **Dados Cadastrais:** Atualização de informações de clientes e colaboradores.

---

## 7. O que é necessário excluir?

O sistema adota a política de **Soft Delete** (`deleted_at`) para manter a integridade referencial e histórica:
- **Registros Operacionais:** Clientes, produtos e planos são marcados como excluídos, mas permanecem no banco para auditoria.
- **Agendamentos:** Cancelamentos exigem registro de motivo e liberam o horário automaticamente na agenda.

---

## 8. O sistema precisa gerar relatórios?

Sim, com visibilidade baseada em nível de acesso:
- **Financeiros:** DRE simplificado, faturamento por método de pagamento e ticket médio (Acesso Admin).
- **Operacionais:** Consumo de produtos, produtividade por profissional e taxa de cancelamento.

---

## 9. O sistema precisa emitir comprovantes?

Sim. Geração de documentos em PDF:
- Recibos de pagamento com detalhamento de descontos e métodos utilizados.
- Extratos de uso de sessões para pacotes e planos.
- Comprovantes de venda de produtos.

---

## 10. O sistema precisa enviar notificações?

Sim. O motor de notificações integra-se ao log de mensagens:
- **Canais:** WhatsApp (Principal) e E-mail (Secundário).
- **Gatilhos:** Confirmação de horário, lembretes de consulta, avisos de parcelas vencidas e promoções.

---

## 11. Como começa o processo (Setup)?

1. **Provisionamento Tenant:** O sistema identifica e isola a nova clínica via CNPJ.
2. **Setup de Parâmetros:** Carga inicial de status, métodos e níveis de acesso padrão.
3. **Criação do Admin:** Vínculo do gestor ao Supabase Auth com proteção de hash Argon2.
4. **Configuração de Operação:** Cadastro inicial de profissionais, produtos e planos.

---

## 12. Segurança e LGPD

- **Isolamento de Dados:** Filtro global obrigatório de `clinica_id` em todas as consultas.
- **Proteção de Identidade:** Senhas protegidas com Argon2 + Salt + Pepper.
- **Privacidade:** Mascaramento de dados sensíveis e logs de acesso a prontuários e CPFs.
- **Concorrência:** Constraints de banco de dados impedindo agendamentos duplicados para o mesmo profissional.

---

## 13. Tecnologias Utilizadas

- **Frontend:** Vue.js 3, Vite, PrimeVue.
- **Backend:** Django (Arquitetura em Camadas).
- **Banco de Dados:** PostgreSQL (JSONB, UUID, INET).
- **Autenticação:** Supabase Auth integrado à implementação customizada de Argon2.

---

## 14. Diagrama de Classes e Relações (ERD)

O modelo atual contempla 4 eixos principais (Configuração, CRM/Recorrência, Operacional/Estoque e Financeiro), garantindo que a regra de negócio seja ditada pelo banco de dados para permitir escalabilidade.

<img width="2079" height="1646" alt="uml_clinica_atualizado" src="https://github.com/user-attachments/assets/735d51c0-a264-4c06-a536-74d8d8b89d03" />


---
