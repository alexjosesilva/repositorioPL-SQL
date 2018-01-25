/* 
  6. Criar uma procedure que deverá receber o código de um cliente e a partir deste dado imprimir o seu
nome, e seu e?mail. Os dados deverão ser obtidos a partir de uma tabela chamada CLIENTE com as
seguintes colunas (COD_CLI,NOME_CLI,EMAIL_CLI)
*/
DECLARE

  PROCEDURE BUSCACLIENTE(CODCLIENTE NUMBER) IS
    VCLIENTE CLIENTE%ROWTYPE;
  BEGIN
    
    SELECT *
     INTO VCLIENTE
    FROM CLIENTE
     WHERE COD_CLI = CODCLIENTE;
    DBMS_OUTPUT.put_line('NOME: '||VCLIENTE.NOME_CLI || 'EMAIL: '||VCLIENTE.EMAIL_CLI); 
    
  END;

BEGIN
 BUSCACLIENTE(20);
END;

