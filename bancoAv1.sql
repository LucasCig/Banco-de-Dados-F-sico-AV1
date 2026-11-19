CREATE DATABASE IF NOT EXISTS salao_beleza;
USE salao_beleza;

CREATE TABLE CLIENTE (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE ESPECIALIDADE (
    idEspecialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(255)
);

CREATE TABLE PROFISSIONAL (
    idProfissional INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE PROFISSIONAL_ESPECIALIDADE (
    idProfissional INT NOT NULL,
    idEspecialidade INT NOT NULL,
    PRIMARY KEY (idProfissional, idEspecialidade),
    CONSTRAINT fk_prof_esp_profissional FOREIGN KEY (idProfissional) REFERENCES PROFISSIONAL(idProfissional),
    CONSTRAINT fk_prof_esp_especialidade FOREIGN KEY (idEspecialidade) REFERENCES ESPECIALIDADE(idEspecialidade)
);

CREATE TABLE SERVICO (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    duracao INT NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    idEspecialidade INT NOT NULL,
    CONSTRAINT fk_servico_especialidade FOREIGN KEY (idEspecialidade) REFERENCES ESPECIALIDADE(idEspecialidade)
);

CREATE TABLE PACOTE (
    idPacote INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE PACOTE_SERVICO (
    idPacote INT NOT NULL,
    idServico INT NOT NULL,
    PRIMARY KEY (idPacote, idServico),
    CONSTRAINT fk_pac_serv_pacote FOREIGN KEY (idPacote) REFERENCES PACOTE(idPacote),
    CONSTRAINT fk_pac_serv_servico FOREIGN KEY (idServico) REFERENCES SERVICO(idServico)
);

CREATE TABLE RESERVA (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Agendada',
    observacoes VARCHAR(255),
    idCliente INT NOT NULL,
    idProfissional INT NOT NULL,
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente),
    CONSTRAINT fk_reserva_profissional FOREIGN KEY (idProfissional) REFERENCES PROFISSIONAL(idProfissional)
);

CREATE TABLE RESERVA_SERVICO (
    idReserva INT NOT NULL,
    idServico INT NOT NULL,
    PRIMARY KEY (idReserva, idServico),
    CONSTRAINT fk_res_serv_reserva FOREIGN KEY (idReserva) REFERENCES RESERVA(idReserva),
    CONSTRAINT fk_res_serv_servico FOREIGN KEY (idServico) REFERENCES SERVICO(idServico)
);

CREATE TABLE RESERVA_PACOTE (
    idReserva INT NOT NULL,
    idPacote INT NOT NULL,
    PRIMARY KEY (idReserva, idPacote),
    CONSTRAINT fk_res_pac_reserva FOREIGN KEY (idReserva) REFERENCES RESERVA(idReserva),
    CONSTRAINT fk_res_pac_pacote FOREIGN KEY (idPacote) REFERENCES PACOTE(idPacote)
);

CREATE TABLE PAGAMENTO (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    formaPagamento VARCHAR(30) NOT NULL DEFAULT 'Cartao de Credito',
    valor DECIMAL(10, 2) NOT NULL,
    dataPagamento DATETIME NOT NULL,
    idReserva INT NOT NULL UNIQUE,
    CONSTRAINT ck_forma_pagamento CHECK (formaPagamento = 'Cartao de Credito'),
    CONSTRAINT fk_pagamento_reserva FOREIGN KEY (idReserva) REFERENCES RESERVA(idReserva)
);

CREATE TABLE FILA_ESPERA (
    idFila INT AUTO_INCREMENT PRIMARY KEY,
    dataHora DATETIME NOT NULL,
    observacoes VARCHAR(255),
    idCliente INT NOT NULL,
    idServico INT NOT NULL,
    idProfissional INT NULL,
    CONSTRAINT fk_fila_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente),
    CONSTRAINT fk_fila_servico FOREIGN KEY (idServico) REFERENCES SERVICO(idServico),
    CONSTRAINT fk_fila_profissional FOREIGN KEY (idProfissional) REFERENCES PROFISSIONAL(idProfissional)
);

INSERT INTO CLIENTE (nome, telefone, email) VALUES
('Mariana Silva', '21988881111', 'mariana.silva@email.com'),
('Lucas Oliveira', '21988882222', 'lucas.oliveira@email.com'),
('Fernanda Costa', '21988883333', 'fernanda.costa@email.com');

INSERT INTO ESPECIALIDADE (nome, descricao) VALUES
('Cabelo', 'Cortes, coloracao, hidratacao e tratamentos capilares'),
('Manicure e Pedicure', 'Cuidados esteticos e esmaltacao das unhas'),
('Estetica Facial', 'Limpeza de pele, design de sobrancelhas e hidratacao');

INSERT INTO PROFISSIONAL (nome, telefone, email) VALUES
('Camila Santos', '21977771111', 'camila.santos@salao.com'),
('Rafael Almeida', '21977772222', 'rafael.almeida@salao.com'),
('Juliana Pereira', '21977773333', 'juliana.pereira@salao.com');

INSERT INTO PROFISSIONAL_ESPECIALIDADE (idProfissional, idEspecialidade) VALUES
(1, 1),
(1, 3),
(2, 1),
(3, 2),
(3, 3);

INSERT INTO SERVICO (nome, descricao, duracao, preco, idEspecialidade) VALUES
('Corte Feminino', 'Corte completo com lavagem e finalizacao', 60, 90.00, 1),
('Escova Modeladora', 'Escova lisa ou modelada', 45, 65.00, 1),
('Manicure Completa', 'Cutilagem e esmaltacao tradicional', 40, 40.00, 2),
('Limpeza de Pele', 'Extracao, esfoliacao e mascara calmante', 90, 150.00, 3);

INSERT INTO PACOTE (nome, descricao, preco) VALUES
('Dia de Beleza Capilar', 'Corte Feminino com Escova Modeladora', 135.00),
('Combo Maos e Rosto', 'Manicure Completa com Limpeza de Pele', 170.00);

INSERT INTO PACOTE_SERVICO (idPacote, idServico) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4);

INSERT INTO RESERVA (data, horario, status, observacoes, idCliente, idProfissional) VALUES
('2026-11-20', '10:00:00', 'Confirmada', 'Cliente solicitou preferencia por Camila', 1, 1),
('2026-11-20', '14:00:00', 'Agendada', 'Atendimento de pacote completo', 2, 3),
('2026-11-21', '09:30:00', 'Ausente', 'Credito de 50% gerado por ausencia', 3, 2);

INSERT INTO RESERVA_SERVICO (idReserva, idServico) VALUES
(1, 1),
(1, 2),
(3, 1);

INSERT INTO RESERVA_PACOTE (idReserva, idPacote) VALUES
(2, 2);

INSERT INTO PAGAMENTO (formaPagamento, valor, dataPagamento, idReserva) VALUES
('Cartao de Credito', 155.00, '2026-11-18 15:20:00', 1),
('Cartao de Credito', 170.00, '2026-11-19 10:05:00', 2),
('Cartao de Credito', 90.00, '2026-11-19 11:40:00', 3);

INSERT INTO FILA_ESPERA (dataHora, observacoes, idCliente, idServico, idProfissional) VALUES
('2026-11-20 10:10:00', 'Aguardando encaixe caso haja atraso superior a 15 min', 3, 1, 1),
('2026-11-20 14:15:00', 'Sem preferencia de profissional', 1, 3, NULL);

SELECT * FROM CLIENTE;
SELECT * FROM ESPECIALIDADE;
SELECT * FROM PROFISSIONAL;
SELECT * FROM PROFISSIONAL_ESPECIALIDADE;
SELECT * FROM SERVICO;
SELECT * FROM PACOTE;
SELECT * FROM PACOTE_SERVICO;
SELECT * FROM RESERVA;
SELECT * FROM RESERVA_SERVICO;
SELECT * FROM RESERVA_PACOTE;
SELECT * FROM PAGAMENTO;
SELECT * FROM FILA_ESPERA;