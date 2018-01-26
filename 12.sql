/* 12. Criar uma função que deverá receber o número de matrícula de um funcionário e retornar o seu nome
e o nome de seu departamento,
*/


DECLARE

  FUNCTION buscarFuncionario (mat NUMBER) 
    RETURN VARCHAR2 IS
    
    RESULTADO VARCHAR2(20);
    NFUN FUNCIONARIO.NOME%TYPE;
    NDEP DEPARTAMENTO.NOME_DEPTO%TYPE;
    
  BEGIN
       SELECT NOME 
        INTO NFUN
       FROM  FUNCIONARIO
        WHERE MATRICULA = mat;
  
       SELECT NOME_DEPTO
        INTO NDEP
      FROM FUNCIONARIO
        INNER JOIN DEPARTAMENTO
        ON FUNCIONARIO.COD_DEPTO = DEPARTAMENTO.COD_DEPTO
        WHERE MATRICULA = mat;
  
      RESULTADO := NFUN || '-' || NDEP;
      
      RETURN RESULTADO;
   END buscarFuncionario;
BEGIN
   SYS.DBMS_OUTPUT.PUT_LINE( buscarFuncionario(1001));
  
END;
   