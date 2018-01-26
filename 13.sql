/* 13. Criar uma trigger para implementar uma restri��o para que o sal�rio do funcion�rio (ver tabela a seguir)
n�o possa ser reduzido.
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
  RAISE_APPLICATION_ERROR (-20508, 'O sal�rio n�o pode ser reduzido');
END;