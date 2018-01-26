/*
14. Criar uma trigger para impedir que o salário do funcionário seja reajustado 
acima de 20% (vinte por cento). Utilize como base a mesma tabela do exercício anterior.
*/

CREATE OR REPLACE TRIGGER AUMENTO
BEFORE UPDATE OF SALARIO ON FUNCIONARIO
FOR EACH ROW
BEGIN
IF (:NEW.SALARIO - :OLD.SALARIO) > :OLD.SALARIO * 0.20 THEN
RAISE_APPLICATION_ERROR (-20512, 'O aumento não deve ser maior que 20%');
END IF;
END;
/