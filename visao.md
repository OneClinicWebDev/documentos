# OneClinic -- Documento de Visão 

> Última atualização: 26 de Fevereiro 2026  
> Status: Inclui alterações do módulo de Autenticação e Controle de Acesso já implementado

---

## Visão Inicial

**1. Qual o principal objetivo do sistema?**

- Centralizar e automatizar a gestão operacional de clínicas de estética de pequeno porte, substituindo controles manuais (cadernos, planilhas, WhatsApp) por um sistema único que integra agenda, financeiro, estoque e relacionamento com clientes.

---

**2. Quais são as principais funcionalidades?**

- Autenticação com login, primeiro acesso (setup) e controle de sessão  
- Controle de acesso por nível (admin, secretário, profissional)  
- Gestão de colaboradores (CRUD completo, admin-only)  
- Sidebar dinâmica filtrada por nível de acesso  
- Nome da clínica configurável no primeiro acesso  
- Cadastro e histórico completo de clientes (sessões, compras, pagamentos)  
- Agendamento de sessões (avulsas, pacotes e planos recorrentes)  
- Controle de estoque de produtos (entradas, saídas, alertas de mínimo)  
- Gestão financeira com controle de caixa manual (entradas e saídas)  
- Criação e venda de pacotes de sessões e assinaturas  
- Sistema de cupons de desconto  
- Controle de crédito acumulado por cliente  
- Envio e registro de notificações (WhatsApp e e-mail)  
- Geração de relatórios e dashboards  
- Controle de inadimplência (sessões não pagas)

---

**3. Quem vai usar o sistema?**

Três níveis de acesso (atualizado de 2 para 3 níveis):

- **Admin (dono/gestor da clínica):** acesso total a todas as funcionalidades, relatórios, exclusão de registros e configurações. É o primeiro usuário criado no sistema através do fluxo de setup inicial.  
- **Secretário:** acesso à agenda de todos os profissionais, cadastro de clientes, registro de atendimentos, estoque, financeiro operacional (sem relatórios de receita), notificações e caixa manual.  
- **Profissional:** acesso restrito à sua própria agenda, registro de atendimentos, uso de produtos em sessões e consulta de clientes.

> **Alteração em relação ao planejamento original:** O nível "colaborador" foi dividido em dois: "secretário" e "profissional", pois as funções são distintas em uma clínica real. A secretaria precisa gerenciar agenda de todos e registrar pagamentos, enquanto o profissional só precisa ver sua própria agenda.

---

**4. O que você precisa cadastrar?**

- Colaboradores (com nível de acesso: admin, secretário, profissional)  
- Dados da clínica (nome, configurado no primeiro acesso)  
- Clientes (nome, telefone, e-mail, CPF, endereço, crédito)  
- Produtos (nome, descrição, categoria, preços, estoque, mínimo)  
- Planos e pacotes (nome, preço, tipo, total de sessões, duração)  
- Agendamentos (cliente, profissional, data/hora, tipo, valor)  
- Cupons de desconto (código, valor, tipo, validade)  
- Lançamentos de caixa (tipo, valor, descrição, responsável)

---

**5. O que precisa consultar?**

- Histórico completo de um cliente (sessões, compras, pagamentos, crédito)  
- Agenda do dia/semana por profissional  
- Saldo de estoque e alertas de produtos em baixa  
- Sessões não pagas e clientes inadimplentes  
- Saldo de caixa (entradas vs saídas)  
- Sessões restantes de pacotes/planos de cada cliente  
- Histórico de notificações enviadas  
- Relatórios financeiros por período  
- Lista de colaboradores e seus níveis de acesso (admin-only)

---

**6. O que precisa editar?**

- Dados de colaboradores (nome, e-mail, cargo, nível de acesso)  
- Dados cadastrais de clientes  
- Status de agendamentos (modificáveis): pendente, confirmado, cancelado, concluído  
- Status de pagamento de sessões (modificáveis): pago/não pago  
- Quantidades de estoque (entradas e saídas)  
- Informações de planos e pacotes  
- Crédito acumulado de clientes  
- Dados de cupons (validade, usos)

---

**7. O que precisa excluir?**

- Colaboradores (admin-only, com proteção contra autoexclusão)  
- Agendamentos cancelados (com registro de motivo)  
- Clientes inativos (preferencialmente inativação, não exclusão definitiva)  
- Produtos descontinuados  
- Cupons expirados  
- Lançamentos de caixa incorretos (apenas admin)

---

**8. Precisa gerar relatórios?**

- Sim. O sistema gera relatórios de:
  - Receita total e por serviço/período  
  - Sessões realizadas, faltas e presença  
  - Produtos mais usados e histórico de movimentações  
  - Inadimplência e pagamentos pendentes  
  - Fechamento de caixa diário  
  - Clientes mais frequentes e ticket médio  

> Restrição de acesso: apenas Admin acessa relatórios financeiros completos. Rota `/relatorios` protegida com `RequireRole(["admin"])`.

---

**9. Precisa emitir comprovantes?**

- Sim. O sistema deve emitir:
  - Recibos de pagamento em PDF  
  - Comprovantes de sessões realizadas  
  - Comprovantes de compra de produtos  
  - Extratos de crédito do cliente  

---

**10. Precisa enviar notificações?**

- Sim. O sistema registra e envia notificações via:
  - WhatsApp (canal principal para clínicas pequenas)  
  - E-mail como alternativa secundária  
  - Tipos de notificação (modificáveis): pagamentos pendentes, promoções, avisos gerais e lembretes de agendamento  

---

**11. Como começa o processo?**

> O fluxo agora começa antes do uso operacional:

1. **Primeiro acesso (setup):** O dono instala o sistema e é guiado por um wizard de 3 etapas:
   - Etapa 1: Define o nome da clínica  
   - Etapa 2: Preenche seus dados pessoais (nome, e-mail, cargo)  
   - Etapa 3: Define sua senha de acesso  
   - Resultado: conta Admin criada, login automático, redirecionamento ao dashboard  
2. **Cadastro da equipe:** O Admin cadastra secretários e profissionais pela página `/colaboradores`  
3. **Uso operacional:** A partir daqui segue o fluxo original:
   - Cadastro de clientes  
   - Agendamento de sessões  
   - Confirmação de presença  
   - Registro de produtos utilizados  
   - Registro de pagamento  
   - Atualização automática de saldos e histórico  

---

**12. O que acontece depois?**

- O histórico do cliente é atualizado  
- O estoque é ajustado automaticamente  
- O caixa registra a entrada financeira  
- Se houver inadimplência, o sistema sinaliza  
- Notificações podem ser disparadas automaticamente  
- Relatórios são atualizados em tempo real no dashboard  
- Menus da sidebar são atualizados dinamicamente conforme o nível do usuário logado  

---

**13. Quem faz cada parte?**

- **Admin:** cadastra colaboradores, produtos, planos, cupons; gerencia financeiro, relatórios e configurações; atribui funções no sistema aos colaboradores. **[NOVO]** É o primeiro usuário do sistema, criado no setup inicial. Pode editar e excluir qualquer colaborador (exceto a si mesmo).  
- **Secretário:** cadastra clientes, agenda sessões, registra atendimentos, registra uso de produtos, consulta e manipula agenda de todos os profissionais, registra pagamentos e lançamentos de caixa  
- **Profissional:** consulta sua própria agenda e sessões, registra atendimentos, registra uso de produtos  
- **Sistema (automático):** baixa de estoque, cálculo de crédito, alertas de estoque mínimo, controle de validade de planos, **[NOVO]** detecção de primeiro acesso e redirecionamento para setup  

---

**14. Quais dados são obrigatórios?**

- Colaborador: nome, e-mail, cargo, nível de acesso, senha (mínimo 6 caracteres)  
- Clínica: nome (definido no setup)  
- Cliente: nome (mínimo obrigatório)  
- Produto: nome e quantidade em estoque  
- Agendamento: cliente, profissional, data/hora e tipo  
- Plano: nome, preço e tipo  
- Pagamento: cliente, valor e método  
- Cupom: código e valor de desconto  

---

**15. Existe alguma informação sensível?**

- Sim:
  - CPF dos clientes (dado pessoal protegido pela LGPD)  
  - E-mail e telefone (dados de contato)  
  - Senhas dos colaboradores (armazenadas como hash, nunca em texto puro)  
  - Histórico de sessões (pode conter informações de saúde/estética)  
  - Dados financeiros (pagamentos, inadimplência)  

---

**16. Precisa guardar histórico?**

- Sim, o sistema guarda histórico completo de:
  - Todas as sessões realizadas por cliente  
  - Todas as compras de produtos  
  - Todos os pagamentos e recibos  
  - Movimentações de estoque  
  - Notificações enviadas  
  - Lançamentos de caixa  
  - Log de colaboradores cadastrados e seus níveis  

---

**17. Por quanto tempo os dados devem ficar salvos?**

- Dados financeiros: mínimo 5 anos (exigência fiscal brasileira)  
- Dados de clientes: enquanto houver relação comercial ativa, podendo ser anonimizados após inatividade prolongada (LGPD)  
- Histórico de sessões: recomendado manter por pelo menos 2 anos  
- Logs de notificações: 1 ano no mínimo  

---

**18. O sistema precisa controlar pagamentos?**

- Sim. O sistema controla:
  - Pagamentos por sessão (avulsa, pacote, plano)  
  - Vendas de produtos  
  - Múltiplas formas de pagamento (dinheiro, Pix, cartão, boleto)  
  - Descontos e cupons aplicados  
  - Crédito acumulado do cliente  

---

**19. Precisa controlar parcelas?**

- Sim. O sistema suporta:
  - Parcelamento de pacotes e planos  
  - Controle de parcelas pagas e pendentes  
  - Alertas de vencimento  
  - Registro de inadimplência  

---

**20. Precisa emitir recibo?**

- Sim. O sistema emite recibos em PDF contendo:
  - Dados do cliente e da clínica  
  - Descrição do serviço ou produto  
  - Valor pago, desconto aplicado e método de pagamento  
  - Data e identificação do responsável  

---

**21. Precisa saber quem está devendo?**

- Sim. O sistema identifica inadimplência através de:
  - Agendamentos com campo "pago = false"  
  - Parcelas vencidas  
  - Dashboard com lista de devedores  
  - Envio automático de notificações de cobrança  

---

**22. Existem níveis diferentes de acesso?**

> Alterado de 2 para 3 níveis:

- Sim, três níveis:
  - **Admin:** acesso total (cadastros, financeiro, relatórios, exclusões, configurações, gestão de colaboradores)  
  - **Secretário:** acesso operacional (agenda de todos, clientes, estoque, financeiro básico, caixa manual, notificações)  
  - **Profissional:** acesso restrito (agenda própria, atendimentos, consulta de clientes)  

Tabela de permissões por rota:

| Rota | Admin | Secretário | Profissional |
|------|-------|------------|--------------|
| Dashboard `/` | Sim | Sim | Sim |
| Clientes `/clientes` | Sim | Sim | Sim |
| Agenda `/agenda` | Sim | Sim | Sim |
| Planos `/planos` | Sim | Sim | Não |
| Estoque `/estoque` | Sim | Sim | Não |
| Financeiro `/financeiro` | Sim | Sim | Não |
| Caixa `/financeiro/caixa` | Sim | Sim | Não |
| Notificações `/notificacoes` | Sim | Sim | Não |
| Relatórios `/relatorios` | Sim | Não | Não |
| Colaboradores `/colaboradores` | Sim | Não | Não |

> **Alteração no SQL necessária:**
> ```sql
> -- ANTES
> nivel_acesso VARCHAR(20) CHECK (nivel_acesso IN ('admin', 'colaborador'))
> -- DEPOIS
> nivel_acesso VARCHAR(20) CHECK (nivel_acesso IN ('admin', 'secretario', 'profissional'))
> ```

---

**23. Funcionários podem ver tudo?**

- Não. Colaboradores têm acesso limitado:
  - Sidebar filtra menus automaticamente pelo nível de acesso  
  - Páginas restritas exibem tela de "Acesso Negado" se o nível não for permitido  
  - Profissionais veem apenas sua própria agenda e clientes que atendem  
  - Secretários não acessam relatórios financeiros completos nem gestão de colaboradores  
  - Nenhum colaborador pode excluir registros (apenas admin)  

---

**24. Apenas o dono pode excluir algo?**

- Sim. Exclusão de registros é restrita ao nível admin:
  - Exclusão de colaboradores (com proteção contra autoexclusão)  
  - Exclusão de clientes, produtos, planos  
  - Cancelamento de pagamentos  
  - Estorno de lançamentos de caixa  
  - Colaboradores podem apenas cancelar agendamentos próprios, porém com notificações ao admin  

---

**25. Você pretende expandir o negócio?**

- O sistema foi projetado para ser escalável:
  - Estrutura modular que permite adicionar novas funcionalidades  
  - Banco de dados relacional que suporta crescimento  
  - Interface responsiva que funciona em desktop e mobile  

---

**26. Pode ter mais unidades?**

- Atualmente o sistema atende uma única unidade  
- Para multiunidades seria necessário adicionar:
  - Tabela de unidades/filiais  
  - Vínculo de colaboradores e estoque por unidade  
  - Relatórios consolidados e por filial  
  - A arquitetura atual permite essa expansão com ajustes no banco de dados  

---

**27. Vai aumentar o número de usuários?**

- O sistema suporta crescimento gradual:
  - Cadastro ilimitado de colaboradores com diferentes níveis de acesso  
  - Banco de dados SQL que suporta milhares de registros sem perda de desempenho  
  - A interface foi construída para acomodar listagens grandes com paginação e filtros  
  - Para crescimento significativo, pode-se adicionar cache e otimizações de consulta  

---

## Apêndice: Componentes Implementados

| Componente | Arquivo | Descrição |
|------------|---------|-----------|
| AuthProvider | `/lib/auth.tsx` | Contexto global de autenticação |
| Setup Page | `/app/setup/page.tsx` | Wizard de primeiro acesso (3 etapas) |
| Login Page | `/app/login/page.tsx` | Tela de login com e-mail e senha |
| AuthGuard | `/components/auth-guard.tsx` | Protetor de rotas por nível |
| AppShell | `/components/app-shell.tsx` | Shell condicional (com/sem sidebar) |
| Sidebar | `/components/sidebar.tsx` | Menu lateral filtrado por nível |
| UserNav | `/components/user-nav.tsx` | Menu do usuário com logout |
| Colaboradores | `/app/colaboradores/page.tsx` | CRUD de colaboradores (admin-only) |
