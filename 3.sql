/* 3. Criar um bloco PL/SQL para apresentar os anos bissextos entre 2000 e 2100. Um ano ser� bissexto
quando for poss�vel dividi?lo por 4, mas n�o por 100 ou quando for poss�vel dividi?lo por 400. */

DECLARE

BEGIN

 FOR I IN 2000..2100 LOOP
 
   IF( MOD(I,4) = 0 AND MOD(I,100) != 0) OR MOD(I,400)=0 THEN
    DBMS_OUTPUT.PUT_LINE(I);
   END IF;
   
 END LOOP;

END;