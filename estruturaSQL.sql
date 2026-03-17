-- 1. EXTENSÕES DE ELITE
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "btree_gist"; -- Necessário para o índice de exclusão (conflito)

-- 2. EIXO 1: CONFIGURAÇÃO E IDENTIDADE (TENANCY)
CREATE TABLE clinicas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parametros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    tipo VARCHAR(50) NOT NULL, -- ex: 'status_agenda', 'canal_msg'
    codigo VARCHAR(50) NOT NULL, -- ex: 'CONFIRMADO', 'WHATSAPP'
    nome VARCHAR(100) NOT NULL,
    dados JSONB DEFAULT '{}',
    ativo BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT unique_param_clinica UNIQUE (clinica_id, tipo, codigo)
);

-- 3. EIXO 2: CRM E FIDELIZAÇÃO (COM STATUS DINÂMICO)
CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11),
    telefone VARCHAR(20),
    credito NUMERIC(15,2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT unique_cliente_clinica UNIQUE (clinica_id, cpf)
);

CREATE TABLE planos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    nome VARCHAR(100) NOT NULL,
    total_sessoes INTEGER NOT NULL,
    preco NUMERIC(15,2) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMPTZ
);

CREATE TABLE assinaturas_clientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id), -- Denormalização p/ Performance/RLS
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    plano_id UUID NOT NULL REFERENCES planos(id),
    status_id UUID NOT NULL REFERENCES parametros(id), -- Corrigido: Agora usa Parametros
    sessoes_restantes INTEGER NOT NULL,
    data_expiracao DATE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. EIXO 3: COLABORADORES E COMUNICAÇÃO (ENXUTO)
CREATE TABLE colaboradores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    nivel_acesso_id UUID NOT NULL REFERENCES parametros(id),
    supabase_uid UUID UNIQUE NOT NULL, -- Autenticação delegada ao Supabase
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT unique_email_clinica UNIQUE (clinica_id, email)
);

CREATE TABLE mensagens_enviadas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    status_id UUID NOT NULL REFERENCES parametros(id),
    conteudo TEXT NOT NULL,
    data_envio TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. EIXO 4: OPERACIONAL (AGENDA COM BLOQUEIO DE CONFLITO)
CREATE TABLE cupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    codigo VARCHAR(20) NOT NULL,
    valor_desconto NUMERIC(15,2) NOT NULL,
    limite_uso INTEGER DEFAULT 1,
    deleted_at TIMESTAMPTZ,
    CONSTRAINT unique_cupom_clinica UNIQUE (clinica_id, codigo)
);

CREATE TABLE agendamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    profissional_id UUID NOT NULL REFERENCES colaboradores(id),
    status_id UUID NOT NULL REFERENCES parametros(id),
    cupom_id UUID REFERENCES cupons(id),
    assinatura_id UUID REFERENCES assinaturas_clientes(id), -- Rastreia consumo de plano
    data_inicio TIMESTAMPTZ NOT NULL,
    data_fim TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES colaboradores(id),

    -- BLOQUEIO DE CONFLITO DE AGENDA (NÍVEL ARQUITETO PLENO)
    -- Garante que o mesmo profissional não tenha horários sobrepostos (&&)
    -- Exceto se o agendamento for cancelado (logica tratada no status_id via aplicação ou trigger)
    EXCLUDE USING gist (
        profissional_id WITH =,
        tstzrange(data_inicio, data_fim) WITH &&
    )
);

CREATE TABLE cupons_usos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    cupom_id UUID NOT NULL REFERENCES cupons(id),
    cliente_id UUID NOT NULL REFERENCES clientes(id),
    agendamento_id UUID REFERENCES agendamentos(id),
    usado_em TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. EIXO 5: FINANCEIRO (COMPLETO E DENORMALIZADO)
CREATE TABLE pagamentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id), -- Adicionado p/ RLS
    agendamento_id UUID NOT NULL REFERENCES agendamentos(id),
    metodo_id UUID NOT NULL REFERENCES parametros(id),
    valor_bruto NUMERIC(15,2) NOT NULL,
    desconto NUMERIC(15,2) DEFAULT 0.00,
    valor_liquido NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parcelas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinica_id UUID NOT NULL REFERENCES clinicas(id), -- Adicionado p/ RLS
    pagamento_id UUID NOT NULL REFERENCES pagamentos(id),
    status_id UUID NOT NULL REFERENCES parametros(id), -- ex: PAGO, PENDENTE, ATRASADO
    valor NUMERIC(15,2) NOT NULL,
    vencimento DATE NOT NULL,
    data_pagamento TIMESTAMPTZ
);

-- 7. AUDITORIA
CREATE TABLE logs_sistema (
    id BIGSERIAL PRIMARY KEY,
    clinica_id UUID NOT NULL REFERENCES clinicas(id),
    colaborador_id UUID REFERENCES colaboradores(id),
    tabela VARCHAR(50) NOT NULL,
    acao VARCHAR(20) NOT NULL,
    dados_antigos JSONB,
    dados_novos JSONB,
    ip_origem INET,
    timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
