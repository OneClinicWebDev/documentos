# OneClinic
## Especificação de Requisitos, Regras de Negócio e Requisitos Não Funcionais

**Versão:** 2.0 — Especificação consolidada  
**Data:** 16 de outubro de 2026  
**Produto:** Sistema de Gestão Inteligente para Clínicas de Estética  
**Público-alvo:** Clínicas de estética de pequeno e médio porte  
**País de operação inicial:** Brasil

---

# 1. Introdução

## 1.1. Objetivo

O OneClinic será um sistema SaaS de gestão de clínicas de estética, desenvolvido para centralizar e organizar as principais operações administrativas e de atendimento.

A plataforma deverá permitir que diferentes clínicas utilizem o mesmo sistema de maneira independente, mantendo seus usuários, colaboradores, clientes, serviços, preços, agendas e pacotes isolados.

O sistema deverá permitir que uma mesma pessoa possua vínculos com várias clínicas e desempenhe funções diferentes em cada uma delas.

Esta especificação estabelece:

- Regras de negócio.
- Requisitos funcionais.
- Requisitos não funcionais.
- Restrições de integridade.
- Critérios de aceitação.
- Escopo da primeira versão.
- Pendências que exigem definição adicional.

## 1.2. Objetivos do produto

O OneClinic deverá:

1. Centralizar a gestão de clínicas e colaboradores.
2. Organizar agendamentos e disponibilidade dos profissionais.
3. Permitir que administradores também realizem atendimentos.
4. Controlar pacotes de sessões e seus respectivos saldos.
5. Preservar o histórico das operações.
6. Reduzir conflitos de agenda e erros operacionais.
7. Controlar permissões de acordo com a clínica e o papel do usuário.
8. Facilitar a administração de clínicas com diferentes estruturas de trabalho.
9. Preparar a plataforma para futuras funcionalidades financeiras.
10. Garantir que as regras sejam aplicadas pelo backend, independentemente da interface utilizada.

## 1.3. Escopo da primeira versão

A primeira versão contemplará:

- Autenticação e gerenciamento de acesso.
- Cadastro e administração de clínicas.
- Usuários e vínculos com clínicas.
- Clientes e colaboradores.
- Papéis e permissões.
- Serviços e procedimentos.
- Agenda e agendamentos.
- Férias e afastamentos de colaboradores.
- Substituições e transferências de responsabilidade.
- Registro de atendimentos.
- Pacotes e sessões.
- Histórico e auditoria.
- Notificações internas.
- Processos automáticos de expiração e conclusão.
- Configurações básicas por clínica.

Não farão parte do escopo inicial:

- Prontuário clínico completo.
- Financeiro completo.
- Controle de estoque.
- Emissão fiscal.
- Integrações externas de mensagens.
- Portal completo de administração global da plataforma.
- Aplicativo móvel nativo.

---

# 2. Arquitetura de referência

## 2.1. Tecnologias

A arquitetura definida para o projeto é:

- **Backend:** Python, Django e Django REST Framework.
- **Banco de dados:** PostgreSQL.
- **Provedor do banco:** Supabase, utilizado como hospedagem PostgreSQL.
- **Frontend:** Vue 3, Vite e PrimeVue.
- **Hospedagem prevista do backend:** Render com Gunicorn.
- **Autenticação planejada:** CPF como identificador e JWT para autenticação de API.
- **Migrações:** Django Migrations como fonte de verdade do esquema do banco.

O Supabase Auth não será utilizado.

A estrutura das tabelas deverá ser criada e alterada por meio dos modelos e das migrations do Django, sem manutenção paralela de tabelas manuais no painel do Supabase.

A implementação de JWT ainda deverá respeitar a etapa definida no planejamento técnico.

## 2.2. Princípios arquiteturais

- O backend será responsável pela aplicação das regras de negócio.
- O banco de dados deverá preservar a integridade dos relacionamentos.
- O frontend não poderá substituir as validações do servidor.
- As operações relevantes deverão respeitar o contexto da clínica ativa.
- Os registros históricos importantes não serão excluídos fisicamente.
- As alterações críticas deverão ser auditáveis.
- Os processos automáticos deverão poder ser executados novamente sem duplicar resultados.
- A arquitetura deverá permitir evolução futura sem comprometer o isolamento entre clínicas.

---

# 3. Atores e perfis de acesso

## 3.1. Usuário

Representa uma pessoa cadastrada globalmente no sistema.

Uma pessoa possuirá uma única identidade global, identificada pelo CPF normalizado, e poderá se relacionar com várias clínicas.

## 3.2. ADMIN

Representa o administrador de uma clínica.

É responsável pela gestão administrativa, pelas configurações e pela administração dos vínculos de colaboradores, conforme as permissões do sistema.

O ADMIN também poderá realizar atendimentos e possuir agendamentos próprios.

## 3.3. SECRETARIO

Representa o colaborador responsável pelas operações administrativas da clínica, especialmente agenda, clientes e pacotes, conforme as permissões concedidas.

O sistema poderá exibir o nome do papel como “Secretária” ou “Secretário” na interface, mantendo o identificador técnico padronizado `SECRETARIO`.

## 3.4. PROFISSIONAL

Representa o colaborador que realiza procedimentos ou atendimentos.

Poderá administrar os próprios agendamentos de acordo com a autonomia configurada para a clínica.

## 3.5. CLIENTE

Representa a pessoa atendida pela clínica.

O cliente terá acesso apenas às funcionalidades de cliente disponibilizadas pelo produto, sem receber automaticamente permissões de colaborador.

Tecnicamente, `CLIENTE` será um vínculo separado, e não um papel do vínculo de colaborador.

## 3.6. Superusuário da plataforma

Representa a conta técnica privilegiada do Django, utilizada inicialmente para administração da plataforma.

O superusuário será diferente do ADMIN de uma clínica e não será automaticamente administrador de todas as clínicas.

---

# 4. Regras de negócio (RN)

As regras abaixo descrevem como o sistema deverá se comportar, independentemente da tecnologia utilizada para implementar cada funcionalidade.

## 4.1. Identidade e usuários

### RN-001 — Identificação global por CPF

Cada pessoa terá uma identidade global identificada por CPF normalizado.

O sistema deverá impedir a criação de múltiplos usuários globais com o mesmo CPF normalizado.

### RN-002 — Normalização do CPF

O CPF deverá ser normalizado antes da comparação e persistência, removendo caracteres de formatação e validando o formato e os dígitos verificadores.

### RN-003 — Reutilização de usuário existente

Ao cadastrar um CPF já existente, o sistema deverá reutilizar a identidade global e criar somente o vínculo necessário, quando autorizado.

### RN-004 — Independência entre identidade e clínica

O cadastro global da pessoa será independente de seus vínculos com clínicas.

Desativar um vínculo de colaborador não deverá desativar automaticamente a conta global da pessoa.

### RN-005 — Alterações de credenciais

Uma clínica não poderá redefinir a senha de um usuário existente apenas por cadastrá-lo como cliente ou colaborador.

### RN-006 — Primeiro acesso

O usuário sem senha configurada deverá verificar sua identidade por código enviado ao telefone cadastrado antes de definir a senha.

O código deverá ter validade limitada e proteção contra tentativas abusivas.

### RN-007 — Dados de autenticação

Senhas nunca poderão ser armazenadas em texto puro.

A autenticação e a recuperação de acesso deverão ser independentes das permissões administrativas de uma clínica.

### RN-008 — Múltiplos vínculos

Uma pessoa poderá possuir vínculos com diversas clínicas e exercer papéis diferentes em cada uma delas.

### RN-009 — Cliente e colaborador na mesma clínica

Uma pessoa poderá ser cliente e colaborador da mesma clínica simultaneamente.

Seus vínculos e contextos de acesso deverão ser tratados separadamente.

## 4.2. Clínicas e isolamento

### RN-010 — Criação de clínica

Qualquer usuário poderá criar uma clínica, sem aprovação prévia da plataforma na primeira versão.

### RN-011 — ADMIN inicial

O usuário que criar uma clínica será automaticamente ADMIN dela.

### RN-012 — Isolamento por clínica

Cada clínica terá seus próprios dados operacionais.

O acesso a dados de outra clínica dependerá de um vínculo válido e das permissões aplicáveis.

### RN-013 — Seleção explícita da clínica

Após autenticar-se, o usuário deverá escolher a clínica em que deseja operar, quando possuir mais de uma opção.

O sistema não poderá selecionar silenciosamente um vínculo arbitrário por meio de consultas como `.first()`.

### RN-014 — Validação do contexto

O backend deverá validar o vínculo do usuário com a clínica ativa em todas as operações protegidas.

O identificador de clínica enviado pelo frontend não será suficiente para conceder acesso.

### RN-015 — Independência administrativa

Ser ADMIN em uma clínica não concederá automaticamente o mesmo papel em outras clínicas.

### RN-016 — CNPJ

O CNPJ deverá aceitar os formatos numérico e alfanumérico previstos no padrão oficial aplicável.

O sistema deverá normalizar o valor e validar o formato, os dígitos verificadores e a unicidade.

### RN-017 — Desativação de clínica

A desativação da clínica deverá impedir novas operações incompatíveis com seu estado, preservando os dados históricos.

As condições de acesso para consulta histórica deverão ser aplicadas de forma controlada.

## 4.3. Papéis e permissões

### RN-018 — Papéis padronizados

Os papéis de colaborador serão `ADMIN`, `SECRETARIO` e `PROFISSIONAL`.

O cliente será representado por um vínculo separado.

### RN-019 — Um papel atual por vínculo de colaborador

Cada vínculo de colaborador terá um único papel atual por clínica.

Uma mudança de papel atualizará o papel atual e preservará o histórico.

### RN-020 — Histórico de papéis

Toda alteração de papel deverá registrar o papel anterior, o papel novo, o responsável e a data da alteração.

### RN-021 — Múltiplos administradores

Uma clínica poderá possuir mais de um ADMIN ativo.

### RN-022 — ADMIN como responsável por atendimento

O ADMIN poderá ser selecionado como responsável por um atendimento sem precisar receber um segundo papel de PROFISSIONAL.

### RN-023 — ADMIN sem especialidade obrigatória

O ADMIN poderá realizar atendimentos sem precisar de uma especialidade cadastrada.

Isso não elimina eventuais exigências legais ou profissionais aplicáveis ao procedimento realizado.

### RN-024 — ADMIN e agenda própria

O ADMIN poderá possuir horários, agendamentos e atendimentos próprios.

Ele não será tratado exclusivamente como responsável administrativo.

### RN-025 — Proteção dos administradores

As operações de remoção, desativação e substituição de ADMIN deverão respeitar as regras de proteção da clínica, incluindo a necessidade de preservar um administrador ativo.

A regra definida impede que um ADMIN remova outro ADMIN. A implementação deverá assegurar que os fluxos administrativos não deixem a clínica sem um responsável ativo.

### RN-026 — Autonomia configurável da agenda

A clínica deverá possuir uma configuração que determine o nível de autonomia do profissional para administrar sua própria agenda.

O ADMIN poderá habilitar ou desabilitar essa autonomia.

A configuração deverá ser validada no backend, não apenas escondida ou exibida no frontend.

### RN-027 — Permissões específicas

As permissões de cada papel deverão ser aplicadas no backend.

As permissões ainda não detalhadas para transferência de agendamentos, alteração de preços e consulta de dados de clientes deverão ser definidas antes de serem liberadas.

## 4.4. Colaboradores e ausências

### RN-028 — Início do vínculo

Todo vínculo de colaborador deverá registrar sua data de início.

### RN-029 — Desativação lógica

A desativação do colaborador deverá preservar o vínculo histórico, os atendimentos e os agendamentos anteriores.

### RN-030 — Resolução da agenda antes do desligamento

Um colaborador não poderá ser desativado enquanto existirem agendamentos futuros que ainda precisem de cancelamento ou reatribuição.

### RN-031 — Recontratação

Uma recontratação deverá preservar o vínculo anterior e permitir registrar um novo período de atuação.

### RN-032 — Múltiplos períodos de férias

O sistema deverá permitir vários períodos de férias para um mesmo colaborador.

### RN-033 — Validação de férias

Os períodos de férias deverão ser considerados na validação de disponibilidade da agenda.

Agendamentos conflitantes deverão ser bloqueados ou sinalizados conforme seu estado e as regras de confirmação.

### RN-034 — Responsabilidade provisória

Quando um profissional entrar de férias ou for desativado, o ADMIN ativo mais antigo elegível assumirá provisoriamente a responsabilidade pelos agendamentos afetados até a secretária atribuir outro profissional.

### RN-035 — Separação entre execução e responsabilidade

O sistema deverá distinguir o profissional que realizará o procedimento da pessoa que acompanhará temporariamente o agendamento.

### RN-036 — Histórico de substituição de responsável

Toda alteração de responsabilidade deverá preservar o responsável anterior, o novo responsável, a data e o motivo.

## 4.5. Serviços e preços

### RN-037 — Serviços por clínica

Cada serviço pertencerá a uma clínica e não poderá ser utilizado indevidamente por outra.

### RN-038 — Preço padrão

Cada serviço poderá possuir um preço padrão definido pela clínica.

### RN-039 — Preservação do preço histórico

Alterar o preço padrão do serviço não poderá modificar automaticamente os valores dos agendamentos anteriores.

### RN-040 — Preço aplicado

O agendamento deverá armazenar o valor efetivamente aplicado, separado do preço padrão do serviço.

### RN-041 — Alteração excepcional de preço

Uma alteração excepcional deverá registrar o valor anterior, o novo valor, o responsável e o motivo.

### RN-042 — Desativação de serviço

A desativação de um serviço impedirá novos agendamentos para ele, sem eliminar seu histórico.

## 4.6. Agenda e agendamentos

### RN-043 — Estados do agendamento

Os estados principais serão:

- `PENDENTE`
- `CONFIRMADO`
- `CANCELADO`

O motivo de encerramento será armazenado separadamente do estado.

### RN-044 — Motivos de encerramento

Os motivos técnicos padronizados serão:

- `CLIENTE`
- `CLINICA`
- `REAGENDADO`
- `SUBSTITUICAO`
- `EXPIRADO`

O motivo deverá ser compatível com a operação executada.

### RN-045 — PENDENTE não bloqueia confirmação de outro PENDENTE

Agendamentos PENDENTES poderão se sobrepor a outros PENDENTES, conforme as regras de encaixe.

### RN-046 — Conflito com CONFIRMADO

O sistema não poderá confirmar dois agendamentos incompatíveis para o mesmo profissional.

A verificação deverá ocorrer no backend, inclusive quando duas requisições forem executadas simultaneamente.

### RN-047 — Expiração de PENDENTE

Um agendamento PENDENTE expirará 24 horas após sua criação se não for confirmado.

Ao expirar, será encerrado como `CANCELADO`, com motivo `EXPIRADO`.

### RN-048 — Liberação de horário

Um agendamento expirado ou cancelado não deverá continuar bloqueando o horário como agendamento ativo.

### RN-049 — Reinício do prazo

Se um agendamento retornar ao estado PENDENTE, seu prazo de 24 horas será reiniciado.

### RN-050 — Conclusão automática

Somente agendamentos CONFIRMADOS serão elegíveis à conclusão automática após o horário de término.

Agendamentos PENDENTES nunca serão concluídos automaticamente.

### RN-051 — Atendimento único

A conclusão do agendamento deverá produzir no máximo um registro de Atendimento correspondente.

A execução repetida do processo automático não poderá gerar duplicidade.

### RN-052 — Edição

A edição de um agendamento manterá o mesmo registro e deverá registrar as alterações relevantes.

### RN-053 — Reagendamento

O reagendamento criará um novo registro vinculado ao anterior.

O registro anterior será encerrado com motivo `REAGENDADO`.

### RN-054 — Substituição de cliente

Na substituição de um cliente em um agendamento CONFIRMADO, o registro original será encerrado com motivo `SUBSTITUICAO`, e um novo agendamento será criado para o novo cliente no horário liberado.

O novo registro deverá ficar vinculado ao anterior.

### RN-055 — Histórico de substituição

O registro original não poderá ser sobrescrito para simular a troca de cliente.

Os dois registros deverão ser preservados para auditoria e relatórios.

### RN-056 — Sessão de pacote na substituição

A sessão vinculada ao cliente anterior deverá ser liberada sem desconto automático.

O novo cliente poderá utilizar uma sessão de pacote compatível mediante seleção explícita.

### RN-057 — Novo preço na substituição

O novo agendamento deverá utilizar o preço aplicável ao novo cliente e serviço, respeitando as condições comerciais autorizadas.

### RN-058 — Atendimento que atravessa a meia-noite

A primeira versão não permitirá agendamentos que atravessem a meia-noite.

### RN-059 — Validação de horários

O backend deverá validar início, término, duração, disponibilidade e conflitos antes de confirmar ou alterar agendamentos.

### RN-060 — Motivo e auditoria

Cancelamentos manuais deverão registrar o motivo de encerramento e as informações de auditoria necessárias.

### RN-061 — Preservação dos registros

Agendamentos não poderão ser excluídos fisicamente como forma de cancelar, reagendar ou substituir um registro.

## 4.7. Pacotes e sessões

### RN-062 — Pacote vinculado

Cada pacote pertencerá a uma clínica e a um cliente, e estará associado a um serviço ou procedimento compatível.

### RN-063 — Sessões individuais

As sessões serão geradas individualmente na criação do pacote.

Cada sessão possuirá um identificador e um estado próprio.

### RN-064 — Estados de sessão

Os estados previstos serão:

- `DISPONIVEL`
- `AGENDADA`
- `UTILIZADA`
- `PERDIDA`
- `CANCELADA`
- `EXPIRADA`

### RN-065 — Uma sessão por agendamento ativo

Uma sessão não poderá estar vinculada a mais de um agendamento ativo simultaneamente.

### RN-066 — Seleção explícita

O sistema poderá sugerir pacotes compatíveis, mas a vinculação de uma sessão dependerá de confirmação explícita.

### RN-067 — Saldo derivado

O saldo do pacote será calculado a partir dos estados das sessões, evitando manter contadores independentes que possam divergir.

### RN-068 — Reagendamento de sessão

No reagendamento, a mesma sessão deverá ser transferida para o novo agendamento, sem consumir uma sessão adicional.

### RN-069 — Cancelamento e desconto

Ao cancelar um agendamento associado a pacote, a secretária decidirá se a sessão será preservada ou descontada.

Não haverá desconto automático por falta na primeira versão.

### RN-070 — Correção da decisão

A decisão de descontar ou preservar uma sessão poderá ser corrigida posteriormente por usuário autorizado, com justificativa e auditoria.

### RN-071 — Sessão utilizada

Uma sessão utilizada não poderá ser reaberta silenciosamente.

Correções deverão exigir justificativa e preservar o histórico.

### RN-072 — Validade opcional

O pacote poderá possuir uma validade opcional.

### RN-073 — Prorrogação

A prorrogação da validade deverá ser autorizada e auditada, incluindo a justificativa.

### RN-074 — Cancelamento do pacote

O cancelamento do pacote deverá impedir novas reservas incompatíveis com seu estado, sem apagar o histórico.

### RN-075 — Expiração de agendamento

A expiração de um agendamento PENDENTE deverá liberar a sessão de pacote reservada, sem desconto automático.

### RN-076 — Preparação financeira

A estrutura do pacote deverá permitir registrar valor contratado, data de compra, responsável pela criação e informações necessárias à futura integração financeira.

### RN-077 — Histórico de sessões

Todas as alterações relevantes de estado, reserva, utilização, perda, cancelamento e correção deverão preservar o histórico.

## 4.8. Atendimento

### RN-078 — Registro independente

O Atendimento terá registro próprio, separado do agendamento que lhe deu origem.

### RN-079 — Origem rastreável

Cada Atendimento deverá possuir vínculo com seu agendamento de origem.

### RN-080 — Dados históricos

O Atendimento deverá preservar os valores e as informações relevantes na data em que ocorreu.

### RN-081 — Responsável

O Atendimento poderá ser atribuído a um PROFISSIONAL ou ADMIN elegível.

### RN-082 — Pacote utilizado

Quando houver utilização de pacote, o Atendimento deverá manter o vínculo com a sessão correspondente.

### RN-083 — Sem prontuário clínico

O Atendimento desta versão será um registro operacional e administrativo, não um prontuário clínico completo.

## 4.9. Auditoria

### RN-084 — Auditoria de operações relevantes

As operações críticas deverão gerar registros de auditoria.

### RN-085 — Conteúdo da auditoria

A auditoria deverá identificar, conforme aplicável:

- Usuário responsável.
- Clínica.
- Data e hora.
- Entidade e registro.
- Valores anteriores e posteriores.
- Motivo.
- Origem da operação, quando necessária.

### RN-086 — Processos automáticos

As operações automáticas também deverão preservar histórico e permitir identificar que foram executadas por um processo do sistema.

### RN-087 — Proteção do histórico

Os registros de auditoria não poderão ser alterados por operações comuns da aplicação.

O acesso administrativo deverá ser restrito.

## 4.10. Configuração e notificações

### RN-088 — Configurações por clínica

As configurações operacionais deverão pertencer à clínica correspondente e não poderão ser compartilhadas inadvertidamente entre clínicas.

### RN-089 — Notificações internas

A primeira versão poderá gerar notificações internas relacionadas à agenda, alterações de responsabilidade, pacotes e eventos operacionais.

### RN-090 — Atualização da agenda

A agenda utilizará atualização periódica por polling na primeira versão.

### RN-091 — Canais externos

Integrações de WhatsApp, SMS e outros canais externos ficarão fora do escopo inicial.

---

# 5. Requisitos funcionais (RF)

Os requisitos funcionais descrevem as capacidades que o sistema deverá oferecer.

## 5.1. Autenticação e contas

### RF-001 — Login por CPF

O sistema deverá permitir que o usuário se autentique utilizando CPF e senha, conforme o mecanismo de autenticação implementado.

### RF-002 — Normalização e validação

O sistema deverá normalizar e validar o CPF antes de concluir o login ou o cadastro.

### RF-003 — Primeiro acesso

O sistema deverá permitir verificar o telefone cadastrado por meio de código e definir uma senha no primeiro acesso.

### RF-004 — Recuperação de acesso

O sistema deverá disponibilizar um fluxo seguro de recuperação de senha, com validação de identidade e proteção contra abuso.

### RF-005 — Encerramento de sessão

O sistema deverá permitir encerrar a sessão autenticada e aplicar as regras de expiração e renovação dos tokens adotados.

### RF-006 — Consulta de vínculos

O sistema deverá listar as clínicas e os contextos aos quais o usuário possui acesso.

### RF-007 — Seleção de contexto

O sistema deverá permitir selecionar explicitamente a clínica e o contexto de operação.

### RF-008 — Reutilização de conta

O sistema deverá localizar uma conta existente por CPF e permitir a criação de um novo vínculo sem duplicar a identidade global.

### RF-009 — Proteção de credenciais

O sistema deverá impedir que operações comuns de cadastro ou gestão de colaboradores exponham ou alterem indevidamente as credenciais de outros usuários.

## 5.2. Gestão de clínicas

### RF-010 — Criar clínica

O sistema deverá permitir que um usuário crie uma clínica.

### RF-011 — Criar vínculo administrativo inicial

Ao criar a clínica, o sistema deverá estabelecer o vínculo de ADMIN com o criador.

### RF-012 — Editar clínica

O sistema deverá permitir editar os dados autorizados da clínica.

### RF-013 — Validar CNPJ

O sistema deverá validar e normalizar o CNPJ, incluindo o formato alfanumérico oficial aplicável.

### RF-014 — Ativar ou desativar clínica

O sistema deverá permitir a desativação lógica de uma clínica, conforme as permissões aplicáveis.

### RF-015 — Configurações da clínica

O sistema deverá permitir que o ADMIN configure as opções operacionais previstas, incluindo a autonomia de edição da agenda pelos profissionais.

### RF-016 — Isolamento de dados

Todas as operações de gestão deverão respeitar o contexto da clínica e suas permissões.

## 5.3. Usuários, clientes e colaboradores

### RF-017 — Cadastro de cliente

O sistema deverá permitir cadastrar um cliente e associá-lo à clínica.

### RF-018 — Cadastro de colaborador

O sistema deverá permitir cadastrar um colaborador e atribuir o papel inicial autorizado.

### RF-019 — Busca por CPF

O sistema deverá verificar se o CPF já existe antes de criar uma nova identidade global.

### RF-020 — Gestão de vínculos

O sistema deverá permitir consultar os vínculos do usuário com a clínica, respeitando as permissões.

### RF-021 — Alteração de papel

O sistema deverá permitir a alteração autorizada do papel do colaborador, preservando o histórico.

### RF-022 — Desativação de colaborador

O sistema deverá permitir desativar um vínculo após resolver os agendamentos futuros que exigem tratamento.

### RF-023 — Recontratação

O sistema deverá permitir registrar um novo período de vínculo para uma pessoa anteriormente desligada.

### RF-024 — Gestão de férias

O sistema deverá permitir criar, consultar, editar e cancelar períodos de férias autorizados.

### RF-025 — Consulta de histórico

O sistema deverá permitir consultar o histórico de alterações relevantes dos vínculos, conforme as permissões.

## 5.4. Serviços e especialidades

### RF-026 — Cadastro de serviço

O sistema deverá permitir criar serviços ou procedimentos vinculados à clínica.

### RF-027 — Editar serviço

O sistema deverá permitir editar os dados autorizados do serviço.

### RF-028 — Definir preço padrão

O sistema deverá permitir definir e atualizar o preço padrão do serviço.

### RF-029 — Ativar ou desativar serviço

O sistema deverá permitir desativar serviços sem excluir os registros históricos.

### RF-030 — Cadastro de especialidade

O sistema deverá permitir cadastrar e associar especialidades aos profissionais quando necessário.

### RF-031 — Consulta de serviços

O sistema deverá listar os serviços disponíveis na clínica ativa, respeitando seu estado e as permissões do usuário.

## 5.5. Agenda

### RF-032 — Visualizar agenda

O sistema deverá exibir os agendamentos da clínica conforme o papel, as permissões e o contexto selecionado.

### RF-033 — Filtrar agenda

O sistema deverá permitir filtrar a agenda por data, profissional, cliente, serviço e estado, conforme as permissões.

### RF-034 — Criar agendamento

O sistema deverá permitir criar um agendamento para cliente, serviço, horário e responsável elegíveis.

### RF-035 — Selecionar ADMIN como responsável

O sistema deverá permitir selecionar um ADMIN elegível como responsável por um atendimento.

### RF-036 — Criar agendamento PENDENTE

O sistema deverá permitir criar agendamentos PENDENTES quando o fluxo autorizado assim determinar.

### RF-037 — Confirmar agendamento

O sistema deverá validar disponibilidade, férias, estado do profissional e conflitos antes de confirmar um agendamento.

### RF-038 — Editar agendamento

O sistema deverá permitir editar os campos autorizados de um agendamento, preservando o identificador e registrando as alterações.

### RF-039 — Cancelar agendamento

O sistema deverá permitir cancelar um agendamento, exigindo o motivo correspondente.

### RF-040 — Reagendar

O sistema deverá criar um novo registro para o horário novo e vincular o registro anterior ao novo.

### RF-041 — Substituir cliente

O sistema deverá permitir encerrar o agendamento original com motivo `SUBSTITUICAO` e criar um novo registro para o cliente substituto no horário liberado.

### RF-042 — Validar conflitos

O sistema deverá impedir a confirmação de agendamentos conflitantes para o mesmo profissional, inclusive em operações concorrentes.

### RF-043 — Expirar PENDENTES

O sistema deverá identificar agendamentos PENDENTES vencidos e encerrá-los com motivo `EXPIRADO`.

### RF-044 — Concluir agendamentos

O sistema deverá permitir a conclusão automática de agendamentos CONFIRMADOS elegíveis.

### RF-045 — Prevenir duplicidade de conclusão

O sistema deverá impedir a criação de mais de um Atendimento para o mesmo agendamento concluído.

### RF-046 — Reatribuir profissional

O sistema deverá permitir reatribuir agendamentos a outro profissional autorizado, preservando o histórico.

### RF-047 — Responsabilidade provisória

O sistema deverá identificar agendamentos afetados por férias ou desligamento e permitir a atribuição provisória ao ADMIN elegível.

### RF-048 — Histórico da agenda

O sistema deverá permitir consultar as alterações relevantes do agendamento, incluindo cancelamento, reagendamento, substituição e mudança de responsável.

### RF-049 — Preço aplicado

O sistema deverá registrar o preço aplicado ao agendamento no momento da operação.

### RF-050 — Alterar preço excepcionalmente

O sistema deverá permitir alteração excepcional do valor somente a usuários autorizados, exigindo justificativa e registro de auditoria.

## 5.6. Pacotes

### RF-051 — Criar pacote

O sistema deverá permitir criar um pacote associado a cliente, clínica e serviço compatível.

### RF-052 — Gerar sessões

O sistema deverá gerar as sessões individuais previstas no pacote.

### RF-053 — Consultar saldo

O sistema deverá calcular e exibir o saldo a partir do estado das sessões.

### RF-054 — Consultar histórico

O sistema deverá permitir consultar o histórico do pacote e das suas sessões.

### RF-055 — Sugerir pacote compatível

Durante o agendamento, o sistema poderá apresentar pacotes compatíveis do cliente.

### RF-056 — Vincular sessão

O sistema deverá permitir vincular explicitamente uma sessão disponível a um agendamento.

### RF-057 — Transferir sessão

O sistema deverá permitir transferir a mesma sessão ao novo agendamento em caso de reagendamento.

### RF-058 — Registrar utilização

Na conclusão elegível do atendimento, o sistema deverá registrar a utilização da sessão associada.

### RF-059 — Decidir desconto em cancelamento

O sistema deverá permitir que a secretária decida se uma sessão será preservada ou descontada no cancelamento.

### RF-060 — Corrigir decisão de desconto

O sistema deverá permitir a correção autorizada dessa decisão, exigindo justificativa e auditoria.

### RF-061 — Prorrogar validade

O sistema deverá permitir prorrogar a validade de um pacote quando houver validade configurada, registrando a operação.

### RF-062 — Cancelar pacote

O sistema deverá permitir cancelar um pacote, impedindo novas reservas incompatíveis com seu estado.

### RF-063 — Controlar estados das sessões

O sistema deverá validar as transições de estado das sessões.

### RF-064 — Preparar dados financeiros

O sistema deverá armazenar os dados de pacote necessários à futura integração financeira, conforme os campos definidos no modelo.

## 5.7. Atendimentos

### RF-065 — Criar registro de Atendimento

O sistema deverá criar um registro de Atendimento para cada agendamento concluído elegível.

### RF-066 — Vincular origem

O Atendimento deverá estar vinculado ao agendamento de origem.

### RF-067 — Registrar dados do atendimento

O sistema deverá armazenar cliente, clínica, responsável, serviço, horários previstos, horários reais quando disponíveis, valor aplicado, sessão de pacote e observações administrativas.

### RF-068 — Preservar valores históricos

O sistema deverá preservar os valores e dados relevantes do atendimento no momento em que ocorreu.

### RF-069 — Consultar atendimentos

O sistema deverá permitir consultar os atendimentos de acordo com o contexto da clínica e as permissões.

### RF-070 — Impedir duplicidade

O sistema deverá garantir a unicidade lógica do Atendimento correspondente a cada agendamento concluído.

## 5.8. Auditoria e notificações

### RF-071 — Registrar auditoria

O sistema deverá registrar as operações relevantes de criação, edição, alteração de estado, cancelamento, reatribuição e correção.

### RF-072 — Registrar antes e depois

Quando aplicável, a auditoria deverá registrar os valores anteriores e posteriores da alteração.

### RF-073 — Identificar ator

O sistema deverá identificar o usuário ou processo responsável pela operação.

### RF-074 — Consultar histórico autorizado

O sistema deverá permitir consultar registros históricos e de auditoria somente a usuários autorizados.

### RF-075 — Notificações internas

O sistema deverá permitir gerar notificações internas para eventos operacionais definidos.

### RF-076 — Atualização periódica

O sistema deverá atualizar os dados da agenda por polling na primeira versão.

## 5.9. Administração técnica

### RF-077 — Administração por Django Admin

O superusuário poderá utilizar o Django Admin para as operações técnicas autorizadas.

### RF-078 — Separação da gestão global

O sistema deverá manter separadas a administração global da plataforma e a administração de cada clínica.

### RF-079 — Preparação para portal global

A arquitetura deverá permitir desenvolver futuramente um portal de administração da plataforma sem conceder automaticamente privilégios globais aos ADMINs de clínicas.

---

# 6. Requisitos não funcionais (RNF)

Os requisitos não funcionais estabelecem atributos de qualidade, segurança, operação e manutenção do sistema.

## 6.1. Segurança

### RNF-001 — Senhas seguras

As senhas deverão ser armazenadas por meio de algoritmos de hash apropriados e resistentes a ataques de força bruta, utilizando os mecanismos de segurança do Django e a configuração de hash aprovada para o projeto.

### RNF-002 — Autenticação segura

A autenticação deverá possuir controle de expiração, validação de credenciais e proteção contra tentativas abusivas.

Se JWT for adotado, a configuração deverá contemplar validade dos tokens e estratégia segura de renovação e invalidação.

### RNF-003 — Controle de acesso

Todas as APIs protegidas deverão validar autenticação, vínculo com a clínica, papel e permissões da operação.

### RNF-004 — Isolamento multi-tenant

Nenhum usuário poderá acessar ou modificar dados de outra clínica sem autorização explícita e válida.

### RNF-005 — Segredos fora do código

Senhas de banco, chaves secretas, tokens e demais credenciais deverão permanecer em variáveis de ambiente ou em mecanismo seguro de gerenciamento de segredos.

Arquivos contendo segredos não poderão ser versionados no Git.

### RNF-006 — Proteção de dados sensíveis

CPF, telefone, credenciais e demais dados pessoais deverão ser expostos somente às funcionalidades e aos usuários que realmente precisem deles.

### RNF-007 — Validação no servidor

Dados recebidos do frontend deverão ser validados no backend. A interface não poderá ser considerada uma barreira de segurança.

### RNF-008 — Proteção contra abuso

Login, verificação de telefone e recuperação de senha deverão possuir mecanismos contra força bruta, tentativas excessivas e enumeração indevida de contas.

### RNF-009 — Administração privilegiada

O acesso administrativo privilegiado deverá ser restrito e protegido.

### RNF-010 — Auditoria de segurança

Operações críticas de acesso e alteração de permissões deverão ser auditáveis sem registrar senhas, tokens ou segredos nos logs.

## 6.2. Privacidade e LGPD

### RNF-011 — Finalidade e necessidade

O sistema deverá tratar somente os dados necessários para as finalidades operacionais e contratuais aplicáveis.

### RNF-012 — Controle de acesso a dados pessoais

O acesso a dados pessoais deverá seguir o princípio do menor privilégio.

### RNF-013 — Rastreabilidade

As operações relevantes sobre dados pessoais deverão permitir identificar o responsável e o contexto da alteração.

### RNF-014 — Retenção e exclusão

A política de retenção deverá considerar obrigações legais, contratuais e operacionais.

Pedidos de acesso, correção, exportação ou eliminação deverão ser tratados conforme a legislação aplicável, sem destruir indevidamente registros que precisem ser preservados.

### RNF-015 — Proteção de informações clínicas

Embora o prontuário clínico completo não faça parte da primeira versão, qualquer dado de saúde que venha a ser armazenado deverá receber proteção compatível com sua natureza sensível.

### RNF-016 — Incidentes de segurança

A operação deverá possuir procedimentos para identificar, registrar, avaliar e tratar incidentes envolvendo dados pessoais.

## 6.3. Integridade e consistência

### RNF-017 — Integridade referencial

Os relacionamentos entre usuários, clínicas, colaboradores, clientes, agendamentos, atendimentos e pacotes deverão preservar a integridade dos dados.

### RNF-018 — Transações

Operações que alterem conjuntamente agendamentos, sessões de pacote e registros relacionados deverão utilizar transações atômicas quando necessário.

### RNF-019 — Concorrência

O backend deverá tratar operações concorrentes que possam produzir confirmações conflitantes, sessões duplicadas ou alterações inconsistentes.

### RNF-020 — Idempotência

Processos automáticos de conclusão, expiração e outras rotinas repetíveis deverão poder ser executados novamente sem produzir efeitos duplicados.

### RNF-021 — Restrições no banco

Restrições de unicidade, integridade e consistência deverão ser implementadas no banco sempre que apropriado, além das validações da aplicação.

### RNF-022 — Histórico consistente

Alterações em cadastros não deverão reescrever indevidamente os dados históricos de agendamentos e atendimentos.

## 6.4. Desempenho e escalabilidade

### RNF-023 — Consultas eficientes

As APIs deverão utilizar consultas eficientes, evitando carregamentos desnecessários de relacionamentos e consultas repetitivas.

### RNF-024 — Paginação

Listagens potencialmente extensas deverão possuir paginação.

### RNF-025 — Índices

O banco deverá possuir índices adequados para os campos frequentemente utilizados em buscas e filtros, incluindo identificadores, vínculos e datas operacionais.

### RNF-026 — Crescimento multi-tenant

A arquitetura deverá permitir o crescimento do número de clínicas e usuários sem exigir que cada clínica possua uma aplicação independente.

### RNF-027 — Metas de desempenho

As metas quantitativas de latência, volume de usuários simultâneos e capacidade de processamento deverão ser definidas por testes e conforme o ambiente contratado.

Não deverá ser presumida uma meta de desempenho que ainda não tenha sido validada.

## 6.5. Disponibilidade e recuperação

### RNF-028 — Tratamento de falhas

Falhas de API, banco ou processos automáticos deverão ser tratadas sem deixar alterações parcialmente aplicadas.

### RNF-029 — Backup

Deverá existir uma estratégia de backup do PostgreSQL compatível com a importância dos dados.

### RNF-030 — Recuperação

O projeto deverá definir procedimentos de restauração e validação da integridade após falhas.

### RNF-031 — Monitoramento

O ambiente deverá permitir identificar erros relevantes do backend e falhas nas tarefas automáticas.

### RNF-032 — Tarefas automáticas

A falha temporária de uma tarefa de expiração ou conclusão deverá permitir nova execução controlada.

### RNF-033 — Metas de disponibilidade

A disponibilidade contratual e os objetivos de recuperação deverão ser definidos de acordo com a infraestrutura e o estágio do produto.

## 6.6. Manutenibilidade e evolução

### RNF-034 — Separação de responsabilidades

A aplicação deverá manter separadas as responsabilidades de modelos, validações, permissões, serviços de negócio, APIs e apresentação.

### RNF-035 — Fonte de verdade das migrations

As migrations do Django deverão ser a fonte de verdade da evolução do esquema do banco.

### RNF-036 — Código legível

O código deverá manter nomenclatura consistente, responsabilidades claras e estrutura que facilite correções e evolução.

### RNF-037 — Configuração por ambiente

As configurações de desenvolvimento, teste e produção deverão ser separadas.

### RNF-038 — Evolução de funcionalidades

A inclusão de funcionalidades futuras não deverá depender de duplicar dados de usuários globais ou enfraquecer o isolamento entre clínicas.

## 6.7. Testabilidade e qualidade

### RNF-039 — Testes automatizados

As regras críticas deverão possuir testes automatizados.

### RNF-040 — Testes de autorização

Deverão existir testes que comprovem que usuários sem permissão não conseguem acessar ou modificar recursos protegidos.

### RNF-041 — Testes de isolamento

Deverão existir testes que verifiquem a impossibilidade de acesso cruzado entre clínicas.

### RNF-042 — Testes de concorrência

As regras de conflito de agenda e reserva de sessões deverão ser testadas em cenários concorrentes.

### RNF-043 — Testes de idempotência

Os processos automáticos deverão ser testados para confirmar que execuções repetidas não duplicam atendimentos nem consomem sessões indevidamente.

### RNF-044 — Testes de regressão

Correções e novas funcionalidades não deverão invalidar as regras de negócio já aprovadas.

## 6.8. Compatibilidade e usabilidade

### RNF-045 — Interface responsiva

O frontend deverá ser utilizável em computadores, tablets e dispositivos móveis.

### RNF-046 — Consistência de interface

A interface deverá apresentar estados, permissões, mensagens de validação e ações de maneira consistente.

### RNF-047 — Mensagens de erro

Erros deverão ser apresentados de forma compreensível, sem expor detalhes internos, credenciais ou informações sensíveis.

### RNF-048 — Fuso horário

O sistema deverá armazenar e processar horários de forma consistente e exibi-los conforme o fuso configurado para a clínica.

### RNF-049 — Acessibilidade

A interface deverá seguir boas práticas de acessibilidade, incluindo navegação por teclado, rótulos de campos e contraste adequado.

## 6.9. Implantação e operação

### RNF-050 — Ambientes separados

Desenvolvimento, testes e produção deverão possuir configurações e credenciais independentes.

### RNF-051 — Migrations controladas

As alterações estruturais do banco deverão ser versionadas, revisadas e aplicadas de forma controlada.

### RNF-052 — CORS

O backend deverá permitir requisições somente das origens autorizadas para cada ambiente.

### RNF-053 — HTTPS

A comunicação em produção deverá utilizar HTTPS.

### RNF-054 — Logs

Os logs operacionais deverão auxiliar no diagnóstico sem registrar credenciais ou dados pessoais desnecessários.

### RNF-055 — Processos agendados

As tarefas de expiração e conclusão deverão possuir configuração operacional, monitoramento e possibilidade de reexecução.

---

# 7. Modelo conceitual de dados

O modelo definitivo será produzido durante o planejamento das migrations. A estrutura conceitual deverá contemplar, no mínimo, as seguintes entidades.

## 7.1. Identidade e acesso

**Usuario**

- Identidade global.
- CPF normalizado e único.
- Nome.
- Data de nascimento, quando necessária.
- Telefone cadastrado.
- Estado da conta.
- Campos de autenticação fornecidos ou herdados dos modelos Django.
- Datas de criação e atualização.

**Clinica**

- Dados de identificação.
- CNPJ.
- Razão social e nome fantasia, quando aplicáveis.
- Contatos.
- Estado ativo ou inativo.
- Datas de criação e atualização.

**Colaborador**

- Usuário.
- Clínica.
- Papel atual.
- Data de início.
- Data de fim, quando desativado.
- Estado do vínculo.

**HistoricoPapel**

- Colaborador.
- Papel anterior.
- Papel novo.
- Responsável pela alteração.
- Data e motivo.

**VinculoCliente**

- Usuário.
- Clínica.
- Estado do vínculo.
- Datas relevantes.

**ConfiguracaoClinica**

- Clínica.
- Configurações operacionais.
- Autonomia de edição da agenda.
- Datas de atualização.

## 7.2. Serviços e disponibilidade

**Servico**

- Clínica.
- Nome e descrição.
- Duração.
- Preço padrão.
- Estado.

**Especialidade**

- Identificação da especialidade.
- Dados necessários ao cadastro.

**ColaboradorEspecialidade**

- Colaborador.
- Especialidade.

**PeriodoFerias**

- Colaborador.
- Data inicial.
- Data final.
- Estado.

**HorarioDisponibilidade**

- Responsável.
- Dia ou período de disponibilidade.
- Horários.
- Regras de recorrência, quando aplicáveis.

## 7.3. Agenda e atendimento

**Agendamento**

- Clínica.
- Cliente.
- Serviço.
- Responsável pela execução.
- Responsável temporário, quando aplicável.
- Início e término.
- Status.
- Motivo de encerramento.
- Valor padrão de referência.
- Valor aplicado.
- Agendamento de origem ou registro anterior.
- Criador e datas relevantes.

**Atendimento**

- Clínica.
- Agendamento de origem.
- Cliente.
- Responsável.
- Serviço.
- Horários previstos e reais.
- Valor aplicado.
- Sessão de pacote, quando aplicável.
- Status.
- Observações administrativas.
- Datas de criação e atualização.

## 7.4. Pacotes

**Pacote**

- Clínica.
- Cliente.
- Serviço.
- Quantidade de sessões.
- Valor contratado, quando aplicável.
- Data de compra.
- Validade opcional.
- Estado.
- Responsável pela criação.

**SessaoPacote**

- Pacote.
- Número da sessão.
- Estado.
- Agendamento ativo, quando aplicável.
- Atendimento relacionado, quando aplicável.
- Datas relevantes.

**HistoricoSessaoPacote**

- Sessão.
- Estado anterior.
- Estado novo.
- Responsável.
- Data.
- Motivo.
- Agendamento ou atendimento relacionado.

## 7.5. Auditoria e notificações

**Auditoria**

- Usuário ou processo responsável.
- Clínica, quando aplicável.
- Entidade.
- Identificador do registro.
- Ação.
- Valores anteriores e posteriores.
- Motivo.
- Data e hora.
- Informações técnicas estritamente necessárias.

**Notificacao**

- Destinatário.
- Clínica.
- Tipo de evento.
- Conteúdo.
- Estado de leitura.
- Data de criação.

Os nomes apresentados são conceituais. Os nomes finais das classes, campos e relacionamentos deverão ser definidos na implementação, mantendo as regras de integridade.

---

# 8. Critérios de aceitação dos fluxos críticos

## CA-001 — CPF existente

**Dado** que uma pessoa já possui cadastro global,  
**quando** uma clínica cadastrar seu CPF,  
**então** o sistema deverá reutilizar a identidade e criar somente o vínculo autorizado, sem duplicar a conta.

## CA-002 — Usuário com várias clínicas

**Dado** que um usuário possui vínculos com duas clínicas,  
**quando** selecionar uma delas,  
**então** todas as operações deverão ocorrer no contexto selecionado, sem acesso automático aos dados da outra clínica.

## CA-003 — ADMIN que atende

**Dado** que uma pessoa possui papel ADMIN na clínica,  
**quando** for necessário atribuí-la a um atendimento,  
**então** ela deverá ser selecionável sem precisar receber um segundo papel de PROFISSIONAL ou uma especialidade obrigatória no sistema.

## CA-004 — Conflito de confirmação

**Dado** que existe um agendamento CONFIRMADO para um profissional em determinado horário,  
**quando** outro agendamento conflitante for confirmado,  
**então** o backend deverá rejeitar a operação.

## CA-005 — Confirmações simultâneas

**Dado** que duas requisições tentam confirmar agendamentos incompatíveis simultaneamente,  
**quando** ambas forem processadas,  
**então** o sistema deverá garantir que não sejam efetivadas confirmações conflitantes.

## CA-006 — Expiração

**Dado** que um agendamento permaneceu PENDENTE por 24 horas,  
**quando** o processo de expiração for executado,  
**então** ele deverá ser encerrado com motivo `EXPIRADO`, liberando o horário e preservando o histórico.

## CA-007 — Reagendamento

**Dado** que existe um agendamento a ser reagendado,  
**quando** o novo horário for criado,  
**então** o sistema deverá manter o registro original, criar um novo registro e vinculá-los.

## CA-008 — Substituição de cliente

**Dado** que existe um agendamento CONFIRMADO,  
**quando** o cliente for substituído,  
**então** o registro anterior deverá ser encerrado com motivo `SUBSTITUICAO`, o novo agendamento deverá ser vinculado ao anterior e eventual sessão do cliente anterior deverá ser liberada sem desconto automático.

## CA-009 — Pacote

**Dado** que uma sessão está vinculada a um agendamento ativo,  
**quando** outra operação tentar vincular a mesma sessão a outro agendamento ativo,  
**então** o backend deverá rejeitar a duplicidade.

## CA-010 — Correção de sessão

**Dado** que uma sessão foi descontada de um pacote,  
**quando** uma pessoa autorizada corrigir a decisão,  
**então** o sistema deverá exigir justificativa e preservar o histórico da alteração.

## CA-011 — Conclusão automática

**Dado** que um agendamento CONFIRMADO atingiu o momento de conclusão,  
**quando** o processo automático for executado mais de uma vez,  
**então** deverá existir somente um registro de Atendimento correspondente.

## CA-012 — Desativação de colaborador

**Dado** que um colaborador possui agendamentos futuros não resolvidos,  
**quando** a desativação for solicitada,  
**então** o sistema deverá impedir a conclusão do desligamento até que os agendamentos sejam tratados.

## CA-013 — Isolamento entre clínicas

**Dado** que um usuário possui acesso a uma clínica, mas não a outra,  
**quando** tentar consultar ou modificar registros da clínica não autorizada,  
**então** o backend deverá negar a operação.

## CA-014 — Preço histórico

**Dado** que um agendamento foi criado com determinado valor aplicado,  
**quando** o preço padrão do serviço for alterado,  
**então** o valor histórico do agendamento não deverá ser modificado automaticamente.

## CA-015 — Autonomia profissional

**Dado** que a clínica desabilitou a autonomia de edição do profissional,  
**quando** ele tentar executar uma operação não autorizada,  
**então** o backend deverá rejeitá-la, mesmo que a interface seja manipulada.

---

# 9. Escopo excluído da primeira versão

Os itens abaixo deverão ser tratados em fases posteriores:

- Prontuário clínico e histórico médico completo.
- Financeiro completo, contas a pagar e receber.
- Emissão de notas fiscais.
- Controle de estoque.
- Integrações de cobrança.
- Envio automatizado de lembretes por WhatsApp, SMS ou e-mail.
- Portal global de administração da plataforma.
- Aplicativo móvel nativo.
- Transferência de pacotes entre clientes.
- WebSockets para atualização em tempo real.

A exclusão dessas funcionalidades não impede que os modelos sejam projetados de forma a permitir evolução futura.

---

# 10. Pendências que precisam de decisão

Os itens abaixo não devem ser considerados regras definitivas até serem aprovados.

## 10.1. Permissões do profissional

Definir se o profissional poderá:

- Transferir agendamentos para outros profissionais.
- Alterar o preço aplicado.
- Visualizar o telefone do cliente.
- Visualizar agendas de outros profissionais.
- Cancelar agendamentos de outros profissionais.

A regra já estabelecida é que a autonomia sobre a própria agenda poderá ser configurada pelo ADMIN. Os limites exatos das operações acima ainda precisam ser especificados.

## 10.2. Estados dos pacotes

Detalhar:

- O que acontece quando uma sessão expira enquanto existe um agendamento futuro.
- Como tratar um pacote cancelado que possui sessões reservadas.
- Em quais condições sessões utilizadas, perdidas ou expiradas poderão ser reativadas.
- Quais transições entre estados são permitidas.

## 10.3. Cancelamento

Os códigos de motivo já estão definidos. Ainda é necessário especificar se haverá um campo de justificativa textual obrigatório para todos os cancelamentos manuais e em quais casos ele será exigido.

## 10.4. Responsabilidade provisória

Detalhar os critérios de elegibilidade e desempate quando existirem vários ADMINs ativos, incluindo a regra de antiguidade e o tratamento de ausências do próprio ADMIN.

## 10.5. Superusuário

Definir precisamente quais dados das clínicas o superusuário poderá consultar e alterar no Django Admin e quais operações deverão ser auditadas.

## 10.6. Requisitos quantitativos

Estabelecer metas de desempenho, disponibilidade, volume de usuários simultâneos, frequência de backups e objetivos de recuperação de acordo com a infraestrutura escolhida.

## 10.7. Notificações

Definir os tipos de notificação interna, os eventos que as geram e as regras de leitura e expiração.

---

# 11. Ordem recomendada de implementação

## Etapa 1 — Segurança e estrutura básica

- Revisar credenciais e variáveis de ambiente.
- Corrigir problemas de autenticação e armazenamento de senhas.
- Revisar modelos existentes.
- Validar isolamento entre clínicas.
- Corrigir serializers e permissões.
- Confirmar o estado do banco antes das migrations.

## Etapa 2 — Identidade e vínculos

- Usuario.
- Clinica.
- Colaborador.
- Vínculo de cliente.
- Papéis e histórico.
- Configurações por clínica.
- Seleção explícita do contexto.

## Etapa 3 — Serviços e colaboradores

- Serviços e preços.
- Especialidades.
- Disponibilidade.
- Férias.
- Desativação e recontratação.
- Regras de responsabilidade provisória.

## Etapa 4 — Agenda

- Criação e edição de agendamentos.
- Confirmação e cancelamento.
- Validação transacional de conflitos.
- Reagendamento e substituição.
- Expiração de PENDENTES.
- Conclusão automática.

## Etapa 5 — Pacotes e atendimentos

- Pacotes e sessões.
- Reserva e utilização.
- Cancelamento e correção de desconto.
- Registro de Atendimento.
- Idempotência dos processos automáticos.

## Etapa 6 — Auditoria e operação

- Auditoria centralizada.
- Notificações internas.
- Monitoramento.
- Backups e recuperação.
- Testes de segurança e isolamento.

## Etapa 7 — Integração com frontend

- Ajustar telas e formulários às APIs.
- Implementar seleção de clínica e contexto.
- Aplicar permissões na interface.
- Exibir estados e históricos.
- Validar fluxos completos com testes de integração.

---

# 12. Critério geral de conclusão

Uma funcionalidade somente deverá ser considerada concluída quando:

1. Sua regra de negócio estiver implementada no backend.
2. As permissões forem validadas no servidor.
3. Os dados forem persistidos corretamente.
4. Os relacionamentos respeitarem a integridade do banco.
5. As operações críticas possuírem auditoria.
6. Os testes cobrirem os fluxos normais e os principais casos de erro.
7. O frontend refletir corretamente o comportamento da API.
8. O isolamento entre clínicas estiver preservado.
9. As migrations estiverem versionadas e aplicáveis ao ambiente correspondente.
10. Não houver regressão nas regras já aprovadas.

**Princípio central do OneClinic:** uma pessoa pode ter vários vínculos, cada clínica mantém seus próprios dados e permissões, e o backend é a autoridade responsável por garantir as regras de negócio e a integridade do sistema.
