/* 2. Criar um bloco PL/SQL anônimo para imprimir as tabuadas abaixo:*/
DECLARE

BEGIN
  FOR I IN 1..10 LOOP
    FOR J IN 1..10 LOOP
      DBMS_OUTPUT.PUT_LINE(I ||'x' || J  || '=' || I*J );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
  END LOOP;
END;