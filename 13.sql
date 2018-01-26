/* 13. Criar uma trigger para implementar uma restrição para que o salário do funcionário (ver tabela a seguir)
não possa ser reduzido.
FUNCIONARIO
-----------------------------
MATRICULA NOME SALARIO
-----------------------------
1001 ANTONIO 2500
1002 BEATRIZ 1800
1003 CLAUDIO 1500
-----------------------------
*/

CREATE OR REPLACE TRIGGER TRIGGER1 
BEFORE UPDATE OF SALARIO ON FUNCIONARIO 

FOR EACH ROW
  WHEN (NEW.SALARIO < OLD.SALARIO)

BEGIN
  RAISE_APPLICATION_ERROR (-20508, 'O salário não pode ser reduzido');
END;