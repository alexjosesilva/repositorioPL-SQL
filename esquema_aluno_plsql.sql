-- sugerimos que se coloque os seguintes comandos no arquivo (sem os comentarios)
-- $ORACLE_HOME/sqlplus/admin/glogin.sql
--
-- column data_admissao format a13
-- column data_inicio format a11
-- column nome format a10
-- column sobrenome format a11
-- column email format a12
-- column telefone format a16
-- column nome_departamento format a17
-- column nome_cargo format a23
-- column nome_pais format a12
-- column cod_pais format a8
-- column cod_faixa format a9
-- set linesize 150
-- set pagesize 30

--
-- Inicio do script de criacao dos objetos do curso
--
--spool esquema_aluno.log

-- O script esquema_aluno faz o seguinte:
--   1. Cria as tabelas de exemplo
--   2. Popula as tabelas com dados fictícios

-- Esse script deve ser executado pelo SYSTEM (ou um DBA)
--CONNECT system/manager;

-- Elimina usuaio
--DROP USER aluno CASCADE;

-- Cria usuario
--CREATE USER aluno IDENTIFIED BY senha_aluno;

-- Da permissao para o usuario aluno conectar e criar objetos
--GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE
--    , CREATE SEQUENCE, CREATE TRIGGER, CREATE VIEW
--    , CREATE SYNONYM, ALTER SESSION, CREATE ANY INDEX, CREATE PUBLIC SYNONYM
--    , UNLIMITED TABLESPACE, CREATE ANY DIRECTORY TO aluno;

-- Conecta com o usuario loja
--CONNECT aluno/senha_aluno;

ALTER SESSION SET NLS_NUMERIC_CHARACTERS='.,';

Prompt ***** Dropando os objetos se existirem



DROP TABLE regiao CASCADE CONSTRAINTS PURGE;

DROP TABLE pais CASCADE CONSTRAINTS PURGE;

DROP TABLE localidade CASCADE CONSTRAINTS PURGE;

DROP TABLE departamento CASCADE CONSTRAINTS PURGE;

DROP TABLE cargo CASCADE CONSTRAINTS PURGE;

DROP TABLE funcionario CASCADE CONSTRAINTS PURGE;

DROP TABLE historico_cargo CASCADE CONSTRAINTS PURGE;

DROP TABLE faixa_salario CASCADE CONSTRAINTS PURGE;

DROP TABLE calculo CASCADE CONSTRAINTS PURGE;

DROP TABLE bonus CASCADE CONSTRAINTS PURGE;

DROP TABLE dummy CASCADE CONSTRAINTS PURGE;

DROP TABLE cliente CASCADE CONSTRAINTS PURGE;

DROP TABLE pedido CASCADE CONSTRAINTS PURGE;
     
DROP TABLE item_pedido CASCADE CONSTRAINTS PURGE;
 
DROP TABLE produto CASCADE CONSTRAINTS PURGE;
 
DROP TABLE preco CASCADE CONSTRAINTS PURGE;

DROP SEQUENCE localidade_seq;

DROP SEQUENCE departamento_seq;

DROP SEQUENCE funcionario_seq;

DROP SEQUENCE pedido_seq;

DROP SEQUENCE produto_seq;

DROP SEQUENCE cliente_seq;

DROP VIEW detalhe_funcionario;

DROP VIEW vendas;



Prompt ***** Criando as tabelas



CREATE TABLE regiao
    (cod_regiao        NUMBER       CONSTRAINT cod_regiao_nn NOT NULL,
     nome_regiao       VARCHAR2(30) 
    );

CREATE TABLE pais 
    (cod_pais          CHAR(2)      CONSTRAINT cod_pais_nn NOT NULL,
     nome_pais         VARCHAR2(40),
     cod_regiao        NUMBER,
                                    CONSTRAINT cod_pais_pk PRIMARY KEY (cod_pais) 
    ) ORGANIZATION INDEX; 

CREATE TABLE localidade
    (cod_localidade    NUMBER(4),
     endereco          VARCHAR2(40),
     cep               VARCHAR2(12),
     cidade            VARCHAR2(30) CONSTRAINT localidade_cidade_nn NOT NULL,
     estado            VARCHAR2(25),
     cod_pais          CHAR(2)
    );

CREATE TABLE departamento
    (cod_departamento  NUMBER(4),
     nome_departamento VARCHAR2(30) CONSTRAINT nome_dapartamento_nn NOT NULL,
     cod_gerente       NUMBER(6)
    ,cod_localidade    NUMBER(4)
    );


CREATE TABLE cargo
    (cod_cargo         VARCHAR2(10),
     nome_cargo        VARCHAR2(35) CONSTRAINT nome_cargo_nn NOT NULL,
     menor_salario     NUMBER(6),
     maior_salario     NUMBER(6)
    );

CREATE TABLE funcionario
    (cod_funcionario   NUMBER(6),
     nome              VARCHAR2(20),
     sobrenome         VARCHAR2(25) CONSTRAINT funcionario_sobrenome_nn NOT NULL,
     email             VARCHAR2(25) CONSTRAINT funcionario_email_nn NOT NULL,
     telefone          VARCHAR2(20),
     data_admissao     DATE         CONSTRAINT funcionario_data_contrat_nn NOT NULL,
     cod_cargo         VARCHAR2(10) CONSTRAINT funcionario_cod_cargo_nn NOT NULL,
     salario           NUMBER(8,2),
     comissao          NUMBER(2,2),
     cod_gerente       NUMBER(6),
     cod_departamento  NUMBER(4),
                                    CONSTRAINT funcionario_min_salario_ck CHECK (salario > 0),
                                    CONSTRAINT funcionario_email_uk UNIQUE (email)
    );

CREATE TABLE historico_cargo
    (cod_funcionario   NUMBER(6)    CONSTRAINT historico_cargo_cod_func_nn NOT NULL,
     data_inicio       DATE         CONSTRAINT historico_cargo_data_inicio_nn NOT NULL,
     data_fim          DATE         CONSTRAINT historico_cargo_data_fim_nn NOT NULL,
     cod_cargo         VARCHAR2(10) CONSTRAINT historico_cargo_cod_cargo_nn NOT NULL,
     cod_departamento  NUMBER(4),
                                    CONSTRAINT historico_cargo_interv_data_ck CHECK (data_fim > data_inicio)
    );

CREATE TABLE faixa_salario
    (cod_faixa         VARCHAR2(3),
     menor_salario     NUMBER,
     maior_salario     NUMBER
    );

CREATE TABLE calculo (
     dado              VARCHAR2(10),
     valor             BINARY_FLOAT
);

CREATE TABLE bonus (
     cod_funcionario   VARCHAR2(10),
     cod_cargo         VARCHAR2(9),
     salario           NUMBER,
     comissao          NUMBER
);

CREATE TABLE dummy (
     dummy             NUMBER 
);

CREATE TABLE cliente (
     cod_cliente       NUMBER(6)    CONSTRAINT cliente_cod_cliente_nn NOT NULL,
     nome_cliente      VARCHAR2(45),
     endereco          VARCHAR2(40),
     cidade            VARCHAR2(30),
     estado            VARCHAR2(25),
     cep               VARCHAR2(9),
     telefone          VARCHAR2(20),
     cod_representante NUMBER(4)    CONSTRAINT cliente_cod_representante_nn NOT NULL,
     limite_credito    NUMBER(9,2),
     comentario        LONG,
                                    CONSTRAINT cliente_cod_cliente_ck CHECK (cod_cliente > 0)
);

CREATE TABLE pedido  (
     cod_pedido        NUMBER(4)    CONSTRAINT pedido_cod_pedido_nn NOT NULL,
     data_pedido       DATE,
     plano_comissao    VARCHAR2(1),
     cod_cliente       NUMBER(6)    CONSTRAINT pedido_cod_cliente_nn NOT NULL,
     data_remessa      DATE,
     total             NUMBER(8,2),
                                    CONSTRAINT pedido_total_ck CHECK (total >= 0)
);
     
CREATE TABLE item_pedido (
     cod_pedido        NUMBER(4)    CONSTRAINT item_pedido_cod_pedido_nn NOT NULL,
     cod_item          NUMBER(4)    CONSTRAINT item_pedido_cod_item_nn NOT NULL,
     cod_produto       NUMBER(6),
     preco_atual       NUMBER(8,2),
     quantidade        NUMBER(8),
     total_item        NUMBER(8,2)
);
 
CREATE TABLE produto (
     cod_produto       NUMBER(6),
     descricao         VARCHAR2(30)
);
 
CREATE TABLE preco (
     cod_produto       NUMBER(6)    CONSTRAINT preco_cod_produto_nn NOT NULL,
     preco_padrao      NUMBER(8,2),
     preco_minimo      NUMBER(8,2),
     data_inicio       DATE,
     data_fim          DATE
);     



Prompt ***** Criando as PKs



CREATE UNIQUE INDEX regiao_pk ON regiao (cod_regiao);

ALTER TABLE regiao
ADD (CONSTRAINT regiao_pk PRIMARY KEY (cod_regiao));

CREATE UNIQUE INDEX localidade_pk ON localidade (cod_localidade);

ALTER TABLE localidade
ADD (CONSTRAINT localidade_pk PRIMARY KEY (cod_localidade));

CREATE UNIQUE INDEX departamento_pk
ON departamento (cod_departamento);

ALTER TABLE departamento
ADD (CONSTRAINT departamento_pk PRIMARY KEY (cod_departamento));

CREATE UNIQUE INDEX cargo_pk ON cargo (cod_cargo);

ALTER TABLE cargo
ADD (CONSTRAINT cargo_pk PRIMARY KEY(cod_cargo));

CREATE UNIQUE INDEX funcionario_pk
ON funcionario (cod_funcionario);

ALTER TABLE funcionario
ADD (CONSTRAINT funcionario_pk PRIMARY KEY (cod_funcionario));

CREATE UNIQUE INDEX historico_cargo_pk 
ON historico_cargo (cod_funcionario, data_inicio);

ALTER TABLE historico_cargo
ADD (CONSTRAINT historico_cargo_pk
     PRIMARY KEY (cod_funcionario, data_inicio));

CREATE UNIQUE INDEX cliente_pk
ON cliente (cod_cliente);

ALTER TABLE cliente
ADD (CONSTRAINT cliente_pk PRIMARY KEY (cod_cliente));

CREATE UNIQUE INDEX pedido_pk
ON pedido (cod_pedido);

ALTER TABLE pedido
ADD (CONSTRAINT pedido_pk PRIMARY KEY (cod_pedido));

CREATE UNIQUE INDEX item_pedido_pk
ON item_pedido (cod_pedido,cod_item);

ALTER TABLE item_pedido
ADD (CONSTRAINT item_pedido_pk PRIMARY KEY (cod_pedido,cod_item));

CREATE UNIQUE INDEX produto_pk
ON produto (cod_produto);

ALTER TABLE produto 
ADD (CONSTRAINT produto_pk PRIMARY KEY (cod_produto));



Prompt ***** Criando as Sequencias 



CREATE SEQUENCE localidade_seq   START WITH 3300   INCREMENT BY 100 MAXVALUE 9900 NOCACHE NOCYCLE;
                                                   
CREATE SEQUENCE departamento_seq START WITH 280    INCREMENT BY 10  MAXVALUE 9990 NOCACHE NOCYCLE;
                                                   
CREATE SEQUENCE funcionario_seq  START WITH 207    INCREMENT BY 1                 NOCACHE NOCYCLE;
                                                                                  
CREATE SEQUENCE pedido_seq       START WITH 622    INCREMENT BY 1                 NOCACHE NOCYCLE;
                                                                                  
CREATE SEQUENCE produto_seq      START WITH 200381 INCREMENT BY 1                 NOCACHE NOCYCLE;
                                                                                  
CREATE SEQUENCE cliente_seq      START WITH 109    INCREMENT BY 1                 NOCACHE NOCYCLE;



Prompt ***** Criando as Visoes



CREATE OR REPLACE VIEW detalhe_funcionario
  (cod_funcionario,
   cod_cargo,
   cod_gerente,
   cod_departamento,
   cod_localidade,
   cod_pais,
   nome,
   sobrenome,
   salario,
   comissao,
   nome_departamento,
   nome_cargo,
   cidade,
   estado,
   nome_pais,
   nome_regiao)
AS SELECT
  e.cod_funcionario, 
  e.cod_cargo, 
  e.cod_gerente, 
  e.cod_departamento,
  d.cod_localidade,
  l.cod_pais,
  e.nome,
  e.sobrenome,
  e.salario,
  e.comissao,
  d.nome_departamento,
  j.nome_cargo,
  l.cidade,
  l.estado,
  c.nome_pais,
  r.nome_regiao
FROM
  funcionario e,
  departamento d,
  cargo j,
  localidade l,
  pais c,
  regiao r
WHERE e.cod_departamento = d.cod_departamento
  AND d.cod_localidade = l.cod_localidade
  AND l.cod_pais = c.cod_pais
  AND c.cod_regiao = r.cod_regiao
  AND j.cod_cargo = e.cod_cargo 
WITH READ ONLY;

CREATE OR REPLACE VIEW vendas AS
SELECT   cod_representante,
         pedido.cod_cliente,
         cliente.nome_cliente,
         produto.cod_produto,
         produto.descricao nome_produto,
         SUM(total_item) quantidade
FROM     pedido,
         item_pedido,
         cliente,
         produto
WHERE    pedido.cod_pedido       = item_pedido.cod_pedido
AND      pedido.cod_cliente      = cliente.cod_cliente
AND      item_pedido.cod_produto = produto.cod_produto
GROUP BY cod_representante,
         pedido.cod_cliente,
         cliente.nome_cliente,
         produto.cod_produto,
         produto.descricao;


Prompt ***** Populando as Tabelas



INSERT INTO regiao VALUES 
        ( 1, 'Europa');

INSERT INTO regiao VALUES 
        ( 2, 'Américas');

INSERT INTO regiao VALUES 
        ( 3, 'Ásia');

INSERT INTO regiao VALUES 
        ( 4, 'Oriente Médio e África');


INSERT INTO pais VALUES 
        ( 'BR', 'Brasil', 2);

INSERT INTO pais VALUES 
        ( 'CA', 'Canadá', 2);

INSERT INTO pais VALUES 
        ( 'UK', 'Reino Unido', 1);


INSERT INTO localidade VALUES 
        ( 1400 , 'Rua da Aurora 174', '50060-010', 'Recife', 'PE', 'BR');

INSERT INTO localidade VALUES 
        ( 1500 , 'Rua Haddock Lobo 1048', '01414-000', 'São Paulo', 'SP', 'BR');

INSERT INTO localidade VALUES 
        ( 1700 , 'Rua Duque de Caxias 1187', '90010-282', 'Porto Alegre', 'RS', 'BR');

INSERT INTO localidade VALUES 
        ( 1800 , '460 Bloor St. W.', 'ON M5S 1X8', 'Toronto', 'Ontário', 'CA');

INSERT INTO localidade VALUES 
        ( 2500 , 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');


INSERT INTO departamento VALUES 
        ( 10, 'Administração', 200, 1700);

INSERT INTO departamento VALUES 
        ( 20, 'Marketing', 201, 1800);
                                
INSERT INTO departamento VALUES 
        ( 50, 'Logística', 124, 1500);
                
INSERT INTO departamento VALUES 
        ( 60 , 'Informática', 103, 1400);
                
INSERT INTO departamento VALUES 
        ( 80 , 'Vendas', 149, 2500);
                
INSERT INTO departamento VALUES 
        ( 90 , 'Executivo', 100, 1700);

INSERT INTO departamento VALUES 
        ( 110 , 'Contabilidade', 205, 1700);

INSERT INTO departamento VALUES 
        ( 190 , 'Contratos', NULL, 1700);


INSERT INTO cargo VALUES 
        ( 'AD_PRES', 'Presidente', 20000, 40000);

INSERT INTO cargo VALUES 
        ( 'AD_VP', 'Vice Presidente Administrativo', 15000, 30000);

INSERT INTO cargo VALUES 
        ( 'AD_ASST', 'Assistente Administrativo', 3000, 6000);

INSERT INTO cargo VALUES 
        ( 'CT_GER', 'Gerente de Contas', 8200, 16000);

INSERT INTO cargo VALUES 
        ( 'CTPUB_GER', 'Gerente de Contas Públicas', 4200, 9000);

INSERT INTO cargo VALUES 
        ( 'VE_GER', 'Gerente de Vendas', 10000, 20000);

INSERT INTO cargo VALUES 
        ( 'VE_REP', 'Representante de Vendas', 6000, 12000);

INSERT INTO cargo VALUES 
        ( 'ES_GER', 'Gerente de Estoque', 5500, 8500);

INSERT INTO cargo VALUES 
        ( 'ES_AUX', 'Auxiliar de Estoque', 2000, 5000);

INSERT INTO cargo VALUES 
        ( 'LO_AUX', 'Auxiliar de Logística', 2500, 5500);

INSERT INTO cargo VALUES 
        ( 'TI_PROG', 'Programador', 4000, 10000);

INSERT INTO cargo VALUES 
        ( 'MK_GER', 'Gerente de Marketing', 9000, 15000);

INSERT INTO cargo VALUES 
        ( 'MK_ANA', 'Analista de Marketing', 4000, 9000);


INSERT INTO funcionario VALUES 
        ( 100, 'Roberto', 'Carlos', 'RCARLOS', '051.123.4567',
          TO_DATE('17/06/1997', 'DD/MM/YYYY'), 'AD_PRES', 24000, NULL, NULL, 90);

INSERT INTO funcionario VALUES 
        ( 101, 'Nair', 'Martins', 'NMARTINS', '051.123.4568',
          TO_DATE('21/09/1999', 'DD/MM/YYYY'), 'AD_VP', 17000, NULL, 100, 90);

INSERT INTO funcionario VALUES 
        ( 102, 'Leonardo', 'da Silva', 'LSILVA', '051.123.4569',
          TO_DATE('13/01/2003', 'DD/MM/YYYY'), 'AD_VP', 17000, NULL, 100, 90);

INSERT INTO funcionario VALUES 
        ( 103, 'Alexandre', 'Honorato', 'AHONORATO', '081.423.4567',
          TO_DATE('03/01/2000', 'DD/MM/YYYY'), 'TI_PROG', 9000, NULL, 102, 60);

INSERT INTO funcionario VALUES 
        ( 104, 'Pedro', 'Osterno', 'POSTERNO', '081.423.4568',
          TO_DATE('21/05/2001', 'DD/MM/YYYY'), 'TI_PROG', 6000, NULL, 103, 60);

INSERT INTO funcionario VALUES 
        ( 107, 'Dilma', 'Barata', 'DBARATA', '081.423.5567',
          TO_DATE('07/02/2009', 'DD/MM/YYYY'), 'TI_PROG', 4200, NULL, 103, 60);

INSERT INTO funcionario VALUES 
        ( 124, 'Manuela', 'Brunni', 'MBRUNNI', '011.123.5234',
          TO_DATE('16/11/2008', 'DD/MM/YYYY'), 'ES_GER', 5800, NULL, 100, 50);

INSERT INTO funcionario VALUES 
        ( 141, 'Tomé', 'Lopes', 'TLOPES', '011.121.8009',
          TO_DATE('17/10/2005', 'DD/MM/YYYY'), 'ES_AUX', 3500, NULL, 124, 50);

INSERT INTO funcionario VALUES 
        ( 142, 'Cristóvão', 'Cabral', 'CCABRAL', '011.121.2994',
          TO_DATE('29/01/2007', 'DD/MM/YYYY'), 'ES_AUX', 3100, NULL, 124, 50);

INSERT INTO funcionario VALUES 
        ( 143, 'Rafael', 'Miranda', 'RMIRANDA', '011.121.2874',
          TO_DATE('15/03/2008', 'DD/MM/YYYY'), 'ES_AUX', 2600, NULL, 124, 50);

INSERT INTO funcionario VALUES 
        ( 144, 'Pedro', 'Chaves', 'PCHAVES', '011.121.2004',
          TO_DATE('09/07/2008', 'DD/MM/YYYY'), 'ES_AUX', 2500, NULL, 124, 50);

INSERT INTO funcionario VALUES 
        ( 149, 'Paula', 'Schultz', 'PSCHULTZ', '+44.1344.429018',
          TO_DATE('29/01/2000', 'DD/MM/YYYY'), 'VE_GER', 10500, .2, 100, 80);

INSERT INTO funcionario VALUES 
        ( 174, 'Pamela', 'Sue', 'PSUE', '+44.1644.429267',
          TO_DATE('11/05/2006', 'DD/MM/YYYY'), 'VE_REP', 11000, .30, 149, 80);

INSERT INTO funcionario VALUES 
        ( 176, 'Elias', 'Voorhees', 'EVOORHEES', '+44.1644.429265',
          TO_DATE('24/03/1998', 'DD/MM/YYYY'), 'VE_REP', 8600, .20, 149, 80);

INSERT INTO funcionario VALUES 
        ( 178, 'Sadako', 'Yamamura', 'SYAMAMURA', '+44.1644.429263',
          TO_DATE('24/05/1999', 'DD/MM/YYYY'), 'VE_REP', 7000, .15, 149, NULL);

INSERT INTO funcionario VALUES 
        ( 200, 'Luciana', 'Trajano', 'LTRAJANO', '051.123.4444',
          TO_DATE('17/09/1997', 'DD/MM/YYYY'), 'AD_ASST', 4400, NULL, 101, 10);

INSERT INTO funcionario VALUES 
        ( 201, 'William', 'Thacker', 'WTHACKER', '+1.515.123.5555',
          TO_DATE('17/02/2006', 'DD/MM/YYYY'), 'MK_GER', 13000, NULL, 100, 20);

INSERT INTO funcionario VALUES 
        ( 202, 'Cosmo', 'Kramer', 'CKRAMER', '+1.603.123.6666',
          TO_DATE('17/08/2007', 'DD/MM/YYYY'), 'MK_ANA', 6000, NULL, 201, 20);

INSERT INTO funcionario VALUES 
        ( 205, 'Sheila', 'Almeida', 'SALMEIDA', '051.123.8080',
          TO_DATE('07/06/2004', 'DD/MM/YYYY'), 'CT_GER', 12000, NULL, 101, 110);

INSERT INTO funcionario VALUES 
        ( 206, 'Roberto', 'Nascimento', 'RNASCIMENTO', '051.123.8181',
          TO_DATE('07/06/2004', 'DD/MM/YYYY'), 'CTPUB_GER', 8300, NULL, 205, 110);


INSERT INTO historico_cargo
VALUES (102, TO_DATE('13/01/2003', 'DD/MM/YYYY'),
             TO_DATE('24/07/2008', 'DD/MM/YYYY'), 'TI_PROG', 60);

INSERT INTO historico_cargo
VALUES (101, TO_DATE('21/09/1999', 'DD/MM/YYYY'),
             TO_DATE('27/10/2003', 'DD/MM/YYYY'), 'CTPUB_GER', 110);

INSERT INTO historico_cargo
VALUES (101, TO_DATE('28/10/2003', 'DD/MM/YYYY'),
             TO_DATE('15/03/2007', 'DD/MM/YYYY'), 'CT_GER', 110);

INSERT INTO historico_cargo
VALUES (201, TO_DATE('17/02/2006', 'DD/MM/YYYY'),
             TO_DATE('19/12/2008', 'DD/MM/YYYY'), 'MK_ANA', 20);

INSERT INTO historico_cargo
VALUES (200, TO_DATE('17/09/1997', 'DD/MM/YYYY'),
             TO_DATE('17/06/2003', 'DD/MM/YYYY'), 'AD_ASST', 90);

INSERT INTO historico_cargo
VALUES (176, TO_DATE('24/03/1998', 'DD/MM/YYYY'),
             TO_DATE('31/12/1998', 'DD/MM/YYYY'), 'VE_REP', 80);

INSERT INTO historico_cargo
VALUES (176, TO_DATE('01/01/1999', 'DD/MM/YYYY'),
             TO_DATE('31/12/1999', 'DD/MM/YYYY'), 'VE_GER', 80);

INSERT INTO historico_cargo
VALUES (200, TO_DATE('01/07/2004', 'DD/MM/YYYY'),
             TO_DATE('31/12/2008', 'DD/MM/YYYY'), 'CTPUB_GER', 90);

             
INSERT INTO faixa_salario
VALUES ('A', 1000, 2999);

INSERT INTO faixa_salario
VALUES ('B', 3000, 5999);

INSERT INTO faixa_salario
VALUES('C', 6000, 9999);

INSERT INTO faixa_salario
VALUES('D', 10000, 14999);

INSERT INTO faixa_salario
VALUES('E', 15000, 24999);

INSERT INTO faixa_salario
VALUES('F', 25000, 40000);             


INSERT INTO calculo
VALUES ('INDICADOR1', 'NAN');

INSERT INTO calculo 
VALUES ('INDICADOR2', 'INF');

INSERT INTO calculo
VALUES ('INDICADOR3', '-INF');

INSERT INTO calculo 
VALUES ('INDICADOR4', SQRT(1234563455445.87834578));
  
  
INSERT INTO dummy
VALUES (0);

           
INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('11356-711', 'SP', '174', '011-598-6609',
 'MERCADO DOS ESPORTES',
 '100', '5000', 'SÃO PAULO', 'RUA DOS VISIONARIOS, 345',
 'Bom cliente para se trabalhar.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('11394-061', 'RJ', '176', '021-368-1223',
 'ACME SPORTS',
 '101', '10000', 'RIO DE JANEIRO', 'AV. OSCAR NIEMEYER, 15 SALA 10',
 'Frequentemente muda o pedido. Segurar por 2 dias antes de despachar.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('53945-133', 'PE', '178', '081-644-3341',
 'LOJÃO SUPER ESPORTES',
 '102', '7000', 'RECIFE', 'RUA CAPITÃO ZUZINHA',
 'Empresa iniciando promoção em Julho. Preparar para aumento de pedidos.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('90755-544', 'RS', '176', '051-677-9312',
 'MUNDO WIMBLEDON',
 '103', '3000', 'PORTO ALEGRE', 'AV. GIUSEPPE GARIBALDI, 4357',
 'Contactar representante sobre a nova linha de raquetes de tenis.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('01935-301', 'SP', '178', '011-996-2323',
 'ESPORTES TODO DIA',
 '104', '10000', 'SÃO pAULO', 'RUA IPIRANGA, 44',
 'Cliente com um alto market share (23%) devido a propaganda intensa.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('51951-003', 'PE', '174', '081-376-9966',
 'EBC ESPORTES',
 '105', '5000', 'RECIFE', 'AV. CON. ROSA E SILVA, 1086',
 'Normalmente faz grandes pedidos de uma vez. Considerar aumentar o limite de crédito.');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('01894-301', 'SP', '176', '011-364-9777',
 'ACADEMIA GUEPARDO',
 '106', '6000', 'SÃO PAULO', 'RUA SEQUOIA, 20',
 'Exige muito suporte. Pedidos de pequenas quantidades (< 800).');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('01293-301', 'SP', '178', '011-967-4398',
 'JUST SPORTS',
 '107', '10000', 'SÃO PAULO', 'AV DOS BANDEIRANTES, 1001',
 'Loja de mercadorias esportivas apenas para mulheres. Abertos a novas linhas de produtos!');

INSERT INTO cliente (CEP, ESTADO, COD_REPRESENTANTE, TELEFONE, NOME_CLIENTE,
                     COD_CLIENTE, LIMITE_CREDITO, CIDADE, ENDERECO, COMENTARIO)
VALUES ('01055-649', 'SP', '174', '011-566-9123',
 'BRASIL FITNESS',
 '108', '8000', 'SÃO PAULO', 'RUA COQUEIRAL, 90', '');


INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('101.4', TO_DATE('08/01/2007','DD/MM/YYYY'), '610', TO_DATE('07/01/2007','DD/MM/YYYY'), '101', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('45', TO_DATE('11/01/2007','DD/MM/YYYY'), '611', TO_DATE('11/01/2007','DD/MM/YYYY'), '102', 'B');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('5860', TO_DATE('20/01/2007','DD/MM/YYYY'), '612', TO_DATE('15/01/2007','DD/MM/YYYY'), '104', 'C');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('2.4', TO_DATE('30/05/2006','DD/MM/YYYY'), '601', TO_DATE('01/05/2006','DD/MM/YYYY'), '106', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('56', TO_DATE('20/06/2006','DD/MM/YYYY'), '602', TO_DATE('05/06/2006','DD/MM/YYYY'), '102', 'B');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('698', TO_DATE('30/06/2006','DD/MM/YYYY'), '604', TO_DATE('15/06/2006','DD/MM/YYYY'), '106', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('8324',TO_DATE( '30/07/2006','DD/MM/YYYY'), '605', TO_DATE('14/07/2006','DD/MM/YYYY'), '106', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('3.4', TO_DATE('30/07/2006','DD/MM/YYYY'), '606', TO_DATE('14/07/2006','DD/MM/YYYY'), '100', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('97.5', TO_DATE('15/08/2006','DD/MM/YYYY'), '609', TO_DATE('01/08/2006','DD/MM/YYYY'), '100', 'B');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('5.6', TO_DATE('18/07/2006','DD/MM/YYYY'), '607', TO_DATE('18/07/2006','DD/MM/YYYY'), '104', 'C');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('35.2', TO_DATE('25/07/2006','DD/MM/YYYY'), '608', TO_DATE('25/07/2006','DD/MM/YYYY'), '104', 'C');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('224', TO_DATE('05/06/2006','DD/MM/YYYY'), '603', TO_DATE('05/06/2006','DD/MM/YYYY'), '102', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('4450', TO_DATE('12/03/2007','DD/MM/YYYY'), '620', TO_DATE('12/03/2007','DD/MM/YYYY'), '100', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('6400', TO_DATE('01/02/2007','DD/MM/YYYY'), '613', TO_DATE('01/02/2007','DD/MM/YYYY'), '108', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('23940', TO_DATE('05/02/2007','DD/MM/YYYY'), '614', TO_DATE('01/02/2007','DD/MM/YYYY'), '102', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('764', TO_DATE('10/02/2007','DD/MM/YYYY'), '616', TO_DATE('03/02/2007','DD/MM/YYYY'), '103', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('1260', TO_DATE('04/02/2007','DD/MM/YYYY'), '619', TO_DATE('22/02/2007','DD/MM/YYYY'), '104', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('46370', TO_DATE('03/03/2007','DD/MM/YYYY'), '617', TO_DATE('05/02/2007','DD/MM/YYYY'), '105', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('710', TO_DATE('06/02/2007','DD/MM/YYYY'), '615', TO_DATE('01/02/2007','DD/MM/YYYY'), '107', '');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('3510.5', TO_DATE('06/03/2007','DD/MM/YYYY'), '618', TO_DATE('15/02/2007','DD/MM/YYYY'), '102', 'A');

INSERT INTO pedido (TOTAL, DATA_REMESSA, COD_PEDIDO, DATA_PEDIDO, COD_CLIENTE, PLANO_COMISSAO)
 VALUES ('730', TO_DATE('01/01/2007','DD/MM/YYYY'), '621', TO_DATE('15/03/2007','DD/MM/YYYY'), '100', 'A');


INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '100890', '610', '58', '3', '58');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '1', '100861', '611', '45', '1', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '100', '100860', '612', '3000', '1', '30');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '1', '200376', '601', '2.4', '1', '2.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '20', '100870', '602', '56', '1', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '3', '100890', '604', '174', '1', '58');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '2', '100861', '604', '84', '2', '42');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '10', '100860', '604', '440', '3', '44');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '4', '100860', '603', '224', '2', '56');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '1', '100860', '610', '35', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '3', '100870', '610', '8.4', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '200', '200376', '613', '440', '4', '2.2');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '444', '100860', '614', '15540', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '1000', '100870', '614', '2800', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '20', '100861', '612', '810', '2', '40.5');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('150', '101863', '612', '1500', '3', '10');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '100860', '620', '350', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1000', '200376', '620', '2400', '2', '2.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('500', '102130', '620', '1700', '3', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ( '100', '100871', '613', '560', '1', '5.6');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('200', '101860', '613', '4800', '2', '24');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('150', '200380', '613', '600', '3', '4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '102130', '619', '340', '3', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '100860', '617', '1750', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '100861', '617', '4500', '2', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1000', '100871', '614', '5600', '3', '5.6');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '100861', '616', '450', '1', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '100870', '616', '140', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('2', '100890', '616', '116', '3', '58');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '102130', '616', '34', '4', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '200376' , '616', '24', '5', '2.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '200380', '619', '400', '1', '4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '200376', '619', '240', '2', '2.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('4', '100861', '615', '180', '1', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '100871', '607', '5.6', '1', '5.6');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '100870', '615', '280', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('500', '100870', '617', '1400', '3', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('500', '100871', '617', '2800', '4', '5.6');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('500', '100890', '617', '29000', '5', '58');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '101860', '617', '2400', '6', '24');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('200', '101863', '617', '2500', '7', '12.5');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '102130', '617', '340', '8', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('200', '200376', '617', '480', '9', '2.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('300', '200380', '617', '1200', '10', '4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('5', '100870', '609', '12.5', '2', '2.5');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '100890', '609', '50', '3', '50');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('23', '100860', '618', '805', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '100861', '618', '2255.5', '2', '45.11');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '100870', '618', '450', '3', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '100861', '621', '450', '1', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '100870', '621', '280', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '100871', '615', '250', '3', '5');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '101860', '608', '24', '1', '24');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('2', '100871', '608', '11.2', '2', '5.6');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '100861', '609', '35', '1', '35');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('1', '102130', '606', '3.4', '1', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '100861', '605', '4500', '1', '45');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('500', '100870', '605', '1400', '2', '2.8');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('5', '100890', '605', '290', '3', '58');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '101860', '605', '1200', '4', '24');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '101863', '605', '900', '5', '9');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('10', '102130', '605', '34', '6', '3.4');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('100', '100871', '612', '550', '4', '5.5');

INSERT INTO item_pedido (QUANTIDADE, COD_PRODUTO, COD_PEDIDO, TOTAL_ITEM, COD_ITEM, PRECO_ATUAL)
 VALUES ('50', '100871', '619', '280', '4', '5.6');


INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('4.8', TO_DATE('01/01/1985','DD/MM/YYYY'), '100871', '3.2', TO_DATE('01/12/1985','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('58', TO_DATE('01/01/1985','DD/MM/YYYY'), '100890', '46.4', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('54', TO_DATE('01/06/1984','DD/MM/YYYY'), '100890', '40.5', TO_DATE('31/05/1984','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('35', TO_DATE('01/06/2006','DD/MM/YYYY'), '100860', '28', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('32', TO_DATE('01/01/2006','DD/MM/YYYY'), '100860', '25.6', 
TO_DATE('31/05/2006','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('30', TO_DATE('01/01/1985','DD/MM/YYYY'), '100860', '24', TO_DATE('31/12/1985','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('45', TO_DATE('01/06/2006','DD/MM/YYYY'), '100861', '36', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('42', TO_DATE('01/01/2006','DD/MM/YYYY'), '100861', '33.6', TO_DATE('31/05/2006','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('39', TO_DATE('01/01/1985','DD/MM/YYYY'), '100861', '31.2', TO_DATE('31/12/1985','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('2.8', TO_DATE('01/01/2006','DD/MM/YYYY'), '100870', '2.4', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('2.4', TO_DATE('01/01/1985','DD/MM/YYYY'), '100870', '1.9', TO_DATE('01/12/1985','DD/MM/YYYY'));

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('5.6', TO_DATE('01/01/2006','DD/MM/YYYY'), '100871', '4.8', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('24', TO_DATE('15/02/1985','DD/MM/YYYY'), '101860', '18', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('12.5', TO_DATE('15/02/1985','DD/MM/YYYY'), '101863', '9.4', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('3.4',TO_DATE( '18/08/1985','DD/MM/YYYY'), '102130', '2.8', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('2.4', TO_DATE('15/11/2006','DD/MM/YYYY'), '200376', '1.75', '');

INSERT INTO preco (PRECO_PADRAO, DATA_INICIO, COD_PRODUTO, PRECO_MINIMO, DATA_FIM)
 VALUES ('4', TO_DATE('15/11/2006','DD/MM/YYYY'), '200380', '3.2', '');


INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('100860', 'RAQUETE DE TENIS ACE I');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('100861', 'RAQUETE DE TENIS ACE II');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('100870', 'PACOTE 3 BOLAS TENINS ACE');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('100871', 'PACOTE 6 BOLAS TENINS ACE');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('100890', 'REDE DE TENIS ACE');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('101860', 'RAQUETE DE TENIS SP');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('101863', 'RAQUETE DE TENIS JUNIOR SP');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('102130', 'MANUAL DO TENIS');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('200376', 'BARRA ENERGÉTICA COM 6 VITA');

INSERT INTO produto (COD_PRODUTO, DESCRICAO)
 VALUES ('200380', 'BARRA DE CEREAL COM 6 VITA');

             
COMMIT;



Prompt ***** Criando as FKs



ALTER TABLE pais
ADD (CONSTRAINT pais_regiao_fk FOREIGN KEY (cod_regiao)
     REFERENCES regiao(cod_regiao));

ALTER TABLE localidade
ADD (CONSTRAINT localidade_pais_fk FOREIGN KEY (cod_pais)
     REFERENCES pais(cod_pais));

ALTER TABLE departamento
ADD (CONSTRAINT departmento_localidade_fk FOREIGN KEY (cod_localidade)
     REFERENCES localidade (cod_localidade));

ALTER TABLE departamento
ADD (CONSTRAINT departamento_gerente_fk FOREIGN KEY (cod_gerente)
     REFERENCES funcionario (cod_funcionario));

ALTER TABLE funcionario
ADD (CONSTRAINT funcionario_departamento_fk FOREIGN KEY (cod_departamento)
     REFERENCES departamento (cod_departamento),
     CONSTRAINT funcionario_cargo_fk FOREIGN KEY (cod_cargo)
     REFERENCES cargo (cod_cargo),
     CONSTRAINT funcionario_gerente_fk FOREIGN KEY (cod_gerente)
     REFERENCES funcionario (cod_funcionario));

ALTER TABLE historico_cargo
ADD (CONSTRAINT historico_cargo_cargo_fk FOREIGN KEY (cod_cargo)
     REFERENCES cargo (cod_cargo),
     CONSTRAINT historico_cargo_funcionario_fk FOREIGN KEY (cod_funcionario)
     REFERENCES funcionario (cod_funcionario),
     CONSTRAINT historico_cargo_dept_fk FOREIGN KEY (cod_departamento)
     REFERENCES departamento (cod_departamento));
     
ALTER TABLE pedido
ADD (CONSTRAINT pedido_cliente_fk FOREIGN KEY (cod_cliente)
     REFERENCES cliente (cod_cliente));
     
ALTER TABLE item_pedido 
ADD (CONSTRAINT item_pedido_pedido_fk FOREIGN KEY (cod_pedido)
     REFERENCES pedido (cod_pedido));
     
     
     
Prompt ***** Criando indices



CREATE INDEX funcionario_cod_dept_ix
       ON funcionario (cod_departamento);

CREATE INDEX funcionario_cod_cargo_ix
       ON funcionario (cod_cargo);

CREATE INDEX funcionario_cod_gerente_ix
       ON funcionario (cod_gerente);

CREATE INDEX funcionario_sobrenome_nome_ix
       ON funcionario (sobrenome, nome);

CREATE INDEX departamento_cod_localidade_ix
       ON departamento (cod_localidade);

CREATE INDEX historico_cod_cargo_ix
       ON historico_cargo (cod_cargo);

CREATE INDEX historico_cod_funcionario_ix 
       ON historico_cargo (cod_funcionario);

CREATE INDEX historico_cod_departamento_ix
       ON historico_cargo (cod_departamento);

CREATE INDEX localidade_cidade_ix
       ON localidade (cidade);

CREATE INDEX localidade_estado_ix	
       ON localidade (estado);

CREATE INDEX localidade_pais_ix
       ON localidade (cod_pais);
       
CREATE INDEX preco_cod_produto_data_inic_ix
       ON preco(cod_produto, data_inicio);
