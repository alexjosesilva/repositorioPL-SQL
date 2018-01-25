/* 3. Criar um bloco PL/SQL para apresentar os anos bissextos entre 2000 e 2100. Um ano será bissexto
quando for possível dividi?lo por 4, mas não por 100 ou quando for possível dividi?lo por 400. */

DECLARE

BEGIN

 FOR I IN 2000..2100 LOOP
 
   IF( MOD(I,4) = 0 AND MOD(I,100) != 0) OR MOD(I,400)=0 THEN
    DBMS_OUTPUT.PUT_LINE(I);
   END IF;
   
 END LOOP;

END;