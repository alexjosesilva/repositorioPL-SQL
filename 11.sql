/*
  11. Criar uma fun��o que dever� receber um valor correspondente � temperatura 
  em graus Fahrenheit e retornar o equivalente em graus Celsius. F�rmula para 
  convers�o: C = (F�?�32) / 1.8
*/

DECLARE

  FUNCTION TempC (TempF number) 
    RETURN number
  IS
    
  BEGIN
    
    RETURN ((TempF-32)/1.8);
    
  END TempC;

BEGIN

   DBMS_OUTPUT.PUT_LINE(TempC(50));

END;