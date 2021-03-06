DECLARE

  PROCEDURE CALCULA_IPI(CODPRODUTO NUMBER ) IS
    
  VPRO PRODUTO_TESTE2.VALOR%TYPE;
  VIPI ALIQUOTA.IPI%TYPE;
  TIPI NUMBER(6,2);
    
  BEGIN

 --ENCONTRAR O VALOR DA TABELA PRODUTO
     SELECT P.VALOR
      INTO VPRO
     FROM PRODUTO_TESTE2 P
      WHERE P.CODIGO = CODPRODUTO;
  
 --ENCONTRAR O VALOR DA TABELA IPI
    SELECT A.IPI 
      INTO VIPI 
    FROM PRODUTO_TESTE2 P 
      INNER JOIN ALIQUOTA A
      ON P.CATEGORIA = A.COD_CAT 
    WHERE P.CODIGO = CODPRODUTO;

  --CALCULO DO VALOR DO IP
  TIPI := VPRO * (VIPI/100);
  
  --EXIBIR NA TELA
  DBMS_OUTPUT.PUT_LINE('TOTAL IPI: ' || TIPI);
  END;

BEGIN

  CALCULA_IPI(1003);

END;