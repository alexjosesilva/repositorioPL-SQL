/*
  10. Criar uma função que deverá receber um número inteiro e retornar se o mesmo 
  é primo ou não. 
  (Lembrete: Números primos são divisíveis somente por eles mesmos e por um).
*/

DECLARE

  FUNCTION PRIMO (NUMERO NUMBER) RETURN VARCHAR2 IS
  
  VSQRT NUMBER(4);
  VDIV NUMBER(4);
  VRESULT VARCHAR(20):='É PRIMO';
  
  BEGIN
      --RAIZ QUADRADA DO NUMERO
      VSQRT := SQRT(NUMERO);
      
      FOR I IN 2..VSQRT LOOP
        IF(MOD(NUMERO,I)=0 AND NUMERO<>I)THEN
          VRESULT := 'NAO É PRIMO';
        END IF;
      END LOOP;
      RETURN VRESULT;
  END;

BEGIN
  
  DBMS_OUTPUT.PUT_LINE(PRIMO(4));
  
END;