/*
5. Criar um bloco PL/SQL para imprimir a sequência de Fibonacci: 1  1  2  3  5  8  13  21  34  55
*/

DECLARE

VA NUMBER(2):=1;
VB NUMBER(2):=1;
VC NUMBER(2):=0;

BEGIN

  FOR N IN 1..11 LOOP
     VA := VB;
     VB := VC;
        DBMS_OUTPUT.PUT_LINE(VC);
     VC := VA + VB;         
  END LOOP;

END;