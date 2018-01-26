/*
14. Criar uma trigger para impedir que o sal�rio do funcion�rio seja reajustado 
acima de 20% (vinte por cento). Utilize como base a mesma tabela do exerc�cio anterior.
*/

CREATE OR REPLACE TRIGGER AUMENTO
BEFORE UPDATE OF SALARIO ON FUNCIONARIO
FOR EACH ROW
BEGIN
IF (:NEW.SALARIO - :OLD.SALARIO) > :OLD.SALARIO * 0.20 THEN
RAISE_APPLICATION_ERROR (-20512, 'O aumento n�o deve ser maior que 20%');
END IF;
END;
/