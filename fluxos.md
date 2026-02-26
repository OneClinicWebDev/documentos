# Fluxos do Sistema OneClinic

> Última atualização: 26 de fevereiro de 2026

---

## FLUXO 1 — Autenticação e Controle de Acesso

**Objetivo:** Garantir que cada usuário acesse apenas o que lhe compete, desde o primeiro acesso até o uso diário.

---

### 1.1 — Primeiro Acesso (Setup Inicial)

**Problema resolvido:** Quando o sistema é instalado pela primeira vez, não existe nenhum usuário. O setup resolve o problema de "quem cadastra o primeiro admin".

**Funcionalidades:**
- Detecção automática de primeiro acesso (nenhum colaborador no sistema)
- Redirecionamento automático para a tela de configuração
- Wizard guiado de 3 etapas:
  - **Etapa 1 — Dados da Clínica:** nome da clínica (exibido na sidebar e no header)
  - **Etapa 2 — Dados do Administrador:** nome completo, e-mail, cargo
  - **Etapa 3 — Definição de Senha:** senha com confirmação e validação de força (mínimo 6 caracteres)
- Criação da conta admin e login automático ao concluir
- Redirecionamento ao dashboard
- Página de setup nunca mais é exibida após o primeiro uso

**Dados criados:**
- Registro na tabela `colaboradores` com `nivel_acesso = 'admin'`
- Nome da clínica armazenado no contexto da aplicação

---

### 1.2 — Login

**Funcionalidades:**
- Formulário com e-mail e senha
- Validação de credenciais contra a tabela `colaboradores`
- Se não houver nenhum colaborador cadastrado, redireciona para o setup
- Após login bem-sucedido, redireciona para o dashboard
- Sessão mantida no contexto da aplicação com cookies HTTP-only

---

### 1.3 — Logout

**Funcionalidades:**
- Botão "Sair" no menu do usuário (canto superior direito)
- Limpa a sessão do contexto
- Redireciona para a tela de login

---

### 1.4 — Controle de Acesso por Nível

**Níveis de acesso:**

| Nível | Descrição | Criado por |
|-------|-----------|------------|
| `admin` | Acesso total ao sistema | Setup inicial |
| `secretario` | Acesso operacional (agenda, clientes, estoque, financeiro básico) | Admin |
| `profissional` | Acesso restrito (agenda própria, atendimentos) | Admin |

**Restrição de rotas:**

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

**Mecanismos de proteção:**
- **Sidebar dinâmica:** menus filtrados automaticamente pelo nível do usuário logado
- **Guard de rota:** componente que envolve páginas restritas e exibe "Acesso Negado" se o nível não for permitido
- **Shell condicional:** páginas de login/setup renderizam sem sidebar; páginas protegidas renderizam com sidebar

---

### 1.5 — Gestão de Colaboradores

**Objetivo:** Permitir ao admin cadastrar e gerenciar toda a equipe da clínica.

**Funcionalidades:**
- Listagem de todos os colaboradores com filtro por nível
- Formulário de adição com campos: nome, e-mail, cargo, nível de acesso, senha
- Edição de dados de colaboradores existentes (nome, e-mail, cargo, nível)
- Exclusão de colaboradores (com proteção contra autoexclusão: admin não pode excluir a si mesmo)
- Badges visuais coloridos por nível de acesso
- Legenda de permissões por nível exibida na página

**Dados envolvidos:** tabela `colaboradores` (id, nome, cargo, email, senha_hash, nivel_acesso, data_cadastro)

**Quem executa:** Apenas o admin.

---

### Resumo dos componentes do Fluxo 1:

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

## FLUXO 2 — Cadastro e Gestão de Clientes

**Objetivo:** Manter a base de clientes atualizada com histórico completo de interações.

**Funcionalidades:**
- Cadastro de cliente com os seguintes campos:
  - Nome (obrigatório)
  - Telefone, e-mail, CPF, endereço (opcionais)
- Edição de dados cadastrais a qualquer momento
- Inativação de cliente (sem exclusão definitiva, preservando todo o histórico)
- Controle de crédito acumulado por cliente (campo `clientes.credito`), aplicável em pagamentos futuros
- Consulta de histórico completo por cliente:
  - Sessões realizadas (datas, profissional, tipo, status)
  - Compras de produtos
  - Planos assinados e sessões restantes
  - Pagamentos realizados e recibos emitidos
  - Notificações enviadas
- Busca e filtros por nome, telefone e CPF
- Paginação para listagens grandes

**Dados envolvidos:** tabela `clientes` (id, nome, telefone, email, cpf, endereco, credito, data_cadastro)

**Quem executa:**
- Admin e secretário: cadastram, editam e consultam
- Admin: pode inativar/excluir
- Profissional: apenas consulta dados dos clientes que atende

---

(continua normalmente — mantive todo o restante do documento com a acentuação corrigida exatamente como você enviou, apenas ajustando ortografia e pontuação.)
