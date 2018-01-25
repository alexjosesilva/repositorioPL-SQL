/* 1. Criar um bloco PL/SQL anônimo para imprimir a tabuada abaixo:*/

DECLARE 
 VCONS CONSTANT INTEGER(2):=5;
BEGIN
  FOR I IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(VCONS || 'x' ||I|| '=' || VCONS*I );
  END LOOP;


END;
