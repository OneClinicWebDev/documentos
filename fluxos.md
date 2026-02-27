# Fluxos do Sistema OneClinic  
> Última atualização: 26 de Fevereiro de 2026  

---

# FLUXO 1 — Autenticação e Controle de Acesso

## Objetivo
Garantir que cada usuário acesse apenas o que lhe compete, desde o primeiro acesso até o uso diário.

---

## 1.1 — Primeiro Acesso (Setup Inicial)

### Problema resolvido
Quando o sistema é instalado pela primeira vez, não existe nenhum usuário.  
O setup resolve o problema de "quem cadastra o primeiro admin".

### Funcionalidades

- Detecção automática de primeiro acesso (nenhum colaborador no sistema)
- Redirecionamento automático para a tela de configuração
- Wizard guiado de 3 etapas:

#### Etapa 1 — Dados da Clínica
- Nome da clínica (exibido na sidebar e no header)

#### Etapa 2 — Dados do Administrador
- Nome completo
- E-mail
- Cargo

#### Etapa 3 — Definição de Senha
- Senha com confirmação
- Validação de força (mínimo 6 caracteres)

- Criação da conta admin e login automático ao concluir
- Redirecionamento ao dashboard
- Página de setup nunca mais é exibida após o primeiro uso

### Dados criados

- Registro na tabela `colaboradores` com `nivel_acesso = 'admin'`
- Nome da clínica armazenado no contexto da aplicação

---

## 1.2 — Login

### Funcionalidades

- Formulário com e-mail e senha
- Validação de credenciais contra a tabela `colaboradores`
- Se não houver nenhum colaborador cadastrado, redireciona para o setup
- Após login bem-sucedido, redireciona para o dashboard
- Sessão mantida no contexto da aplicação com cookies HTTP-only

---

## 1.3 — Logout

### Funcionalidades

- Botão "Sair" no menu do usuário (canto superior direito)
- Limpa a sessão do contexto
- Redireciona para a tela de login

---

## 1.4 — Controle de Acesso por Nível

### Níveis de acesso

| Nível | Descrição | Criado por |
|-------|-----------|------------|
| admin | Acesso total ao sistema | Setup inicial |
| secretário | Acesso operacional (agenda, clientes, estoque, financeiro básico) | Admin |
| profissional | Acesso restrito (agenda própria, atendimentos) | Admin |

### Restrição de rotas

| Rota | Admin | Secretário | Profissional |
|------|-------|------------|--------------|
| Dashboard | Sim | Sim | Sim |
| Clientes | Sim | Sim | Sim |
| Agenda | Sim | Sim | Sim |
| Planos e Pacotes | Sim | Sim | Não |
| Estoque | Sim | Sim | Não |
| Financeiro | Sim | Sim | Não |
| Caixa Manual | Sim | Sim | Não |
| Notificações | Sim | Sim | Não |
| Relatórios | Sim | Não | Não |
| Colaboradores | Sim | Não | Não |

### Mecanismos de proteção

- **Sidebar dinâmica:** menus filtrados automaticamente pelo nível do usuário logado  
- **Guard de rota:** componente que envolve páginas restritas e exibe "Acesso Negado" se o nível não for permitido  
- **Shell condicional:** páginas de login/setup renderizam sem sidebar; páginas protegidas renderizam com sidebar  

---

## 1.5 — Gestão de Colaboradores

### Objetivo
Permitir ao admin cadastrar e gerenciar toda a equipe da clínica.

### Funcionalidades

- Listagem de todos os colaboradores com filtro por nível
- Formulário de adição com campos:
  - Nome
  - E-mail
  - Cargo
  - Nível de acesso
  - Senha
- Edição de dados de colaboradores existentes (nome, e-mail, cargo, nível)
- Exclusão de colaboradores (com proteção contra autoexclusão: admin não pode excluir a si mesmo)
- Badges visuais coloridos por nível de acesso
- Legenda de permissões por nível exibida na página

### Dados envolvidos

Tabela `colaboradores`  
Campos:  
`id, nome, cargo, email, senha_hash, nivel_acesso, data_cadastro`

### Quem executa
Apenas o admin.

---

## Resumo dos Componentes do Fluxo 1

| Componente | Função |
|------------|--------|
| AuthProvider | Contexto global de autenticação |
| Setup Page | Wizard de primeiro acesso (3 etapas) |
| Login Page | Tela de login com e-mail e senha |
| AuthGuard | Protetor de rotas por nível de acesso |
| AppShell | Shell condicional (com/sem sidebar) |
| Sidebar | Menu lateral filtrado por nível |
| UserNav | Menu do usuário com logout |
| Colaboradores Page | CRUD de colaboradores (admin) |

---

# FLUXO 2 — Cadastro e Gestão de Clientes

## Objetivo
Manter a base de clientes atualizada com histórico completo de interações.

## Funcionalidades

- Cadastro de cliente com os seguintes campos:
  - Nome (obrigatório)
  - Telefone (opcional)
  - E-mail (opcional)
  - CPF (opcional)
  - Endereço (opcional)

- Edição de dados cadastrais a qualquer momento
- Inativação de cliente (sem exclusão definitiva, preservando todo o histórico)
- Controle de crédito acumulado por cliente (`clientes.credito`), aplicável em pagamentos futuros

### Histórico completo por cliente

- Sessões realizadas (datas, profissional, tipo, status)
- Compras de produtos
- Planos assinados e sessões restantes
- Pagamentos realizados e recibos emitidos
- Notificações enviadas

- Busca e filtros por nome, telefone e CPF
- Paginação para listagens grandes

### Dados envolvidos

Tabela `clientes`  
Campos:  
`id, nome, telefone, email, cpf, endereco, credito, data_cadastro`

### Quem executa

- Admin e secretário: cadastram, editam e consultam
- Admin: pode inativar/excluir
- Profissional: apenas consulta dados dos clientes que atende

### Integração com Fluxo 1

Página acessível por admin, secretário e profissional.  
Ações de exclusão restritas ao admin.

---

# FLUXO 3 — Agenda e Agendamentos

## Objetivo
Organizar e gerenciar todas as sessões da clínica por dia, semana, mês e profissional.

## Funcionalidades

### Visualização

- Por dia (visão detalhada de horários)
- Por semana (visão geral)
- Por profissional (filtro individual)

### Criação de Agendamento

Tipos:
- **Avulsa**
- **Pacote**
- **Plano**

Campos:
- Cliente (obrigatório)
- Profissional (obrigatório)
- Data e hora (obrigatório)
- Tipo (obrigatório)
- Valor da sessão
- Status de pagamento (pago/não pago)
- Observações (opcional)

### Status do Agendamento

- Pendente
- Confirmado
- Cancelado (com registro obrigatório de motivo)
- Concluído

### Produtos vinculados

- Seleção de produtos do estoque
- Definição de quantidade utilizada
- Baixa automática no estoque ao concluir sessão

### Dados envolvidos

Tabelas:  
`agendamentos`, `produtos_usados`

### Integrações

- Fluxo 4: desconta sessões de pacotes/planos
- Fluxo 5: baixa automática no estoque
- Fluxo 6: alimenta controle de inadimplência

---

# FLUXO 4 — Planos, Pacotes e Cupons

## Objetivo
Criar e gerenciar pacotes de sessões, assinaturas recorrentes e cupons de desconto.

## Planos e Pacotes

Campos:
- Nome
- Descrição
- Preço
- Tipo: pacote, mensal ou anual
- Total de sessões
- Duração em dias

Controle automático:
- Data de início e fim
- Sessões restantes
- Status: ativo, vencido, cancelado

## Cupons de Desconto

Campos:
- Código único
- Valor do desconto
- Tipo (porcentagem ou valor fixo)
- Data de validade
- Limite máximo de usos

Validações automáticas:
- Validade
- Limite de usos
- Uso duplicado pelo mesmo cliente

---

# FLUXO 5 — Controle de Estoque

## Objetivo
Gerenciar produtos, registrar movimentações e emitir alertas de reposição.

## Funcionalidades

### Cadastro de Produtos
- Nome
- Descrição
- Categoria
- Preço de compra
- Preço de venda
- Quantidade em estoque
- Quantidade mínima para alerta
- Inativação (sem exclusão)

### Movimentações
Entradas:
- Compra
- Reposição
- Devolução

Saídas:
- Venda direta
- Uso em sessão
- Perda/avaria

### Relatórios
- Produtos mais usados
- Histórico de movimentações
- Produtos críticos
- Valor total do estoque

---

# FLUXO 6 — Financeiro e Controle de Caixa

## Objetivo
Controlar toda a movimentação financeira da clínica.

## Funcionalidades

### Registro de Pagamentos
- Cliente
- Agendamento (quando aplicável)
- Valor
- Método (dinheiro, Pix, cartão, boleto)
- Desconto aplicado
- Promoção aplicada

### Parcelamento
- Controle individual de parcelas
- Alertas de vencimento

### Inadimplência
- Sessões não pagas
- Parcelas vencidas
- Dashboard de devedores

### Caixa Manual
- Entrada ou saída
- Valor
- Descrição
- Responsável
- Fechamento diário

### Recibos
- PDF com dados da clínica
- Dados do cliente
- Descrição
- Valor, desconto e método
- Data e responsável

---

# FLUXO 7 — Notificações e Mensagens

## Objetivo
Comunicar-se com clientes de forma organizada e automatizada.

### Canais
- WhatsApp
- E-mail
- SMS

### Tipos
- Lembrete de agendamento
- Pagamento pendente
- Promoção
- Aviso geral

### Automação
- 24h antes da sessão
- X dias de inadimplência
- Aviso de vencimento de plano

### Histórico
Tabela `mensagens_enviadas`:
`id, cliente_id, tipo, conteudo, canal, data_envio`

---

# FLUXO 8 — Dashboards e Relatórios

## Objetivo
Fornecer visão gerencial do negócio em tempo real.

### Dashboard

Admin:
- Receita do mês
- Sessões realizadas
- Estoque crítico
- Clientes inadimplentes
- Resumo de caixa

Secretário:
- Agenda do dia
- Confirmações pendentes
- Estoque crítico

Profissional:
- Próximos atendimentos
- Sessões realizadas no mês

### Relatórios (admin)
- Financeiro por período
- Desempenho por profissional
- Clientes
- Estoque
- Fechamento de caixa

### Filtros e Exportação
- Por período
- Por cliente
- Por serviço/produto
- Por colaborador
- Exportação em PDF e CSV

---

# Ordem de Implementação

| Ordem | Fluxo | Justificativa |
|-------|-------|---------------|
| 1 | Autenticação e Controle de Acesso | Base para todos os outros fluxos |
| 2 | Cadastro e Gestão de Clientes | Entidade central |
| 3 | Agenda e Agendamentos | Fluxo principal |
| 4 | Planos, Pacotes e Cupons | Complementa agendamentos |
| 5 | Controle de Estoque | Integrado com agenda |
| 6 | Financeiro e Controle de Caixa | Depende de agenda e estoque |
| 7 | Notificações e Mensagens | Depende de clientes |
| 8 | Dashboards e Relatórios | Consolida todos os dados |
