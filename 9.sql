/*
  9. Uma empresa oferece um bônus a seus funcionários com base no lucro liquido (tabela LUCRO) obtido
durante o ano e no valor do salário do funcionário (tabela SALARIO). 
O bônus é calculado conforme a seguinte formula: BONUS = LUCRO * 0.01 + SALARIO * 0.05. 
Crie uma procedure que receba o ano (tabela LUCRO) e número de matricula do 
funcionário e devolva (imprima) o valor do seu respectivo bônus.

*/



CREATE OR REPLACE PROCEDURE CALCULA_BONUS (P_ANO LUCRO.ANO%TYPE,P_MAT SALARIO.MATRICULA%TYPE) IS
 
 V_VL_LUCRO   LUCRO.VALOR%TYPE;
 V_VL_SALARIO SALARIO.VALOR%TYPE;
 V_BONUS      NUMBER(7,2);
 
BEGIN

 SELECT VALOR INTO V_VL_LUCRO FROM LUCRO
 WHERE ANO = P_ANO;

 SELECT VALOR INTO V_VL_SALARIO FROM SALARIO
 WHERE MATRICULA = P_MAT;

 V_BONUS := V_VL_LUCRO * 0.01 + V_VL_SALARIO * 0.05;
 DBMS_OUTPUT.PUT_LINE ('Valor do Bonus: ' || V_BONUS);
 
END;
/

EXECUTE  CALCULA_BONUS (2007,1001); 