# 📘 OneClinic — Requisitos e Regras de Negócio

> Última atualização: 2026
> Status: Em desenvolvimento

---

# 📌 1. Regras de Negócio

## 🔐 1.1 Autenticação e Acesso

* O sistema deve permitir acesso apenas a usuários autenticados.
* Deve existir **apenas um usuário admin inicial**, criado no primeiro acesso (setup).
* Cada usuário possui um nível de acesso:

  * `admin`
  * `secretario`
  * `profissional`
* O acesso às funcionalidades deve ser restrito conforme o nível do usuário.
* Um usuário não pode acessar rotas não autorizadas (validação backend obrigatória).

---

## 👥 1.2 Colaboradores

* Apenas usuários `admin` podem:

  * Criar colaboradores
  * Editar colaboradores
  * Excluir colaboradores
* Um admin **não pode excluir a si mesmo**.
* Cada colaborador deve possuir:

  * Nome
  * E-mail único
  * Senha segura (hash)
  * Nível de acesso

---

## 🧑‍💼 1.3 Clientes

* O campo **nome é obrigatório**.
* Clientes não devem ser excluídos permanentemente:

  * Devem ser **inativados**.
* O sistema deve manter histórico completo do cliente:

  * Agendamentos
  * Pagamentos
  * Produtos
  * Notificações
* Clientes podem possuir crédito acumulado.

---

## 📅 1.4 Agendamentos

* Um agendamento deve possuir:

  * Cliente
  * Profissional
  * Data e hora
* Não pode existir conflito de horário:

  * Mesmo profissional não pode ter dois agendamentos no mesmo horário.
* Status permitidos:

  * `pendente`
  * `confirmado`
  * `cancelado`
  * `concluido`
* Cancelamentos devem registrar motivo.
* Ao concluir:

  * Pode gerar baixa de estoque
  * Pode gerar pendência financeira

---

## 📦 1.5 Estoque

* Produtos devem possuir controle de quantidade.
* Não pode existir estoque negativo.
* Movimentações devem ser registradas:

  * Entrada
  * Saída
* Ao concluir um atendimento:

  * Produtos utilizados devem ser baixados automaticamente.
* Sistema deve alertar quando atingir estoque mínimo.

---

## 💳 1.6 Financeiro

* Todo pagamento deve estar vinculado a:

  * Cliente
  * (Opcional) Agendamento
* Métodos permitidos:

  * Pix
  * Dinheiro
  * Cartão
  * Boleto
* O sistema deve permitir:

  * Parcelamento
  * Registro de desconto
* Sessões não pagas devem gerar inadimplência.

---

## 📉 1.7 Inadimplência

* Um cliente é considerado inadimplente quando:

  * Possui agendamentos não pagos
  * Possui parcelas vencidas
* O sistema deve permitir consulta de inadimplentes.
* Pode haver envio de notificações automáticas.

---

## 🎟️ 1.8 Planos, Pacotes e Cupons

* Planos devem controlar:

  * Sessões restantes
  * Data de validade
* Sessões devem ser decrementadas automaticamente ao uso.
* Cupons devem possuir:

  * Código único
  * Limite de uso
  * Data de validade
* Um cupom não pode ser usado além do limite.

---

## 🔔 1.9 Notificações

* Devem ser registradas no sistema.
* Tipos:

  * Lembrete
  * Cobrança
  * Promoção
* Devem conter:

  * Cliente
  * Conteúdo
  * Canal
  * Data

---

## 📊 1.10 Logs e Auditoria

* O sistema deve registrar:

  * Alterações de dados
  * Exclusões
* Deve armazenar:

  * Usuário responsável
  * Dados antigos e novos
  * Data da ação

---

# 📌 2. Requisitos Funcionais

## 🔐 Autenticação

* RF01 — O sistema deve permitir login com e-mail e senha.
* RF02 — O sistema deve permitir logout.
* RF03 — O sistema deve detectar primeiro acesso e iniciar setup.
* RF04 — O sistema deve manter sessão autenticada.

---

## 👥 Colaboradores

* RF05 — O sistema deve permitir cadastro de colaboradores.
* RF06 — O sistema deve permitir edição de colaboradores.
* RF07 — O sistema deve permitir exclusão de colaboradores (admin).
* RF08 — O sistema deve listar colaboradores.

---

## 🧑‍💼 Clientes

* RF09 — O sistema deve permitir cadastro de clientes.
* RF10 — O sistema deve permitir edição de clientes.
* RF11 — O sistema deve permitir inativação de clientes.
* RF12 — O sistema deve listar clientes com filtros.
* RF13 — O sistema deve exibir histórico completo do cliente.

---

## 📅 Agendamentos

* RF14 — O sistema deve permitir criação de agendamentos.
* RF15 — O sistema deve validar conflitos de horário.
* RF16 — O sistema deve permitir edição de agendamentos.
* RF17 — O sistema deve permitir cancelamento com motivo.
* RF18 — O sistema deve permitir concluir atendimentos.
* RF19 — O sistema deve listar agendamentos por período.

---

## 📦 Estoque

* RF20 — O sistema deve permitir cadastro de produtos.
* RF21 — O sistema deve registrar movimentações de estoque.
* RF22 — O sistema deve baixar estoque automaticamente.
* RF23 — O sistema deve alertar estoque mínimo.

---

## 💳 Financeiro

* RF24 — O sistema deve registrar pagamentos.
* RF25 — O sistema deve permitir parcelamento.
* RF26 — O sistema deve registrar descontos.
* RF27 — O sistema deve controlar inadimplência.

---

## 🎟️ Planos e Cupons

* RF28 — O sistema deve permitir cadastro de planos.
* RF29 — O sistema deve controlar sessões restantes.
* RF30 — O sistema deve permitir criação de cupons.
* RF31 — O sistema deve validar uso de cupons.

---

## 🔔 Notificações

* RF32 — O sistema deve enviar notificações.
* RF33 — O sistema deve registrar histórico de mensagens.

---

## 📊 Relatórios

* RF34 — O sistema deve gerar relatórios financeiros.
* RF35 — O sistema deve gerar relatórios operacionais.

---

# 📌 3. Requisitos Não Funcionais

## 🔒 Segurança

* RNF01 — Senhas devem ser armazenadas com hash seguro (Argon2).
* RNF02 — O sistema deve usar autenticação via token (JWT).
* RNF03 — Dados sensíveis devem ser protegidos conforme LGPD.
* RNF04 — Sessões devem usar cookies HTTP-only.

---

## ⚡ Performance

* RNF05 — O sistema deve suportar múltiplos usuários simultâneos.
* RNF06 — Listagens devem ser paginadas.
* RNF07 — Consultas devem ser otimizadas.

---

## 🧱 Arquitetura

* RNF08 — Backend deve seguir arquitetura em camadas.
* RNF09 — Código deve ser modular.
* RNF10 — Separação clara entre frontend e backend.

---

## 📱 Usabilidade

* RNF11 — Interface deve ser responsiva.
* RNF12 — Interface deve ser simples e intuitiva.
* RNF13 — Ações críticas devem ter feedback visual.

---

## 📊 Confiabilidade

* RNF14 — O sistema deve garantir integridade dos dados.
* RNF15 — Operações financeiras devem usar transações.
* RNF16 — Logs devem ser mantidos para auditoria.

---

## 🔄 Escalabilidade

* RNF17 — O sistema deve suportar crescimento de dados.
* RNF18 — Estrutura deve permitir expansão para multiunidades.

---

# 📌 4. Critérios de Aceite (Resumo)

* Usuário consegue fazer login e acessar apenas o permitido
* Agendamento não permite conflito de horário
* Estoque nunca fica negativo
* Pagamentos refletem corretamente no financeiro
* Cliente possui histórico completo rastreável
* Sistema identifica inadimplentes corretamente

---

# 🚀 5. Status

* [ ] Autenticação
* [ ] Clientes
* [ ] Agenda
* [ ] Financeiro
* [ ] Estoque
* [ ] Notificações
* [ ] Relatórios

---

**OneClinic © — Todos os direitos reservados**
