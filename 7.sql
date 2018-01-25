  /*
  
    7. Criar uma procedure que receberá um RA, um NOME e quatro notas conforme a 
    sequência: (RA,NOME,A1,A2,A3,A4).
    
    A partir destes valores deverá efetuar o cálculo da média somando o maior valor
    entre A1 e A2 às notas A3 e A4 e dividindo o valor obtido por três (achando a média). 
    
    Se a média for menor que 6 (seis) o aluno estará REPROVADO e se a média for 
    igual ou superior a 6 (seis) o aluno estará  APROVADO. 
    
    A procedure deverá inserir os valores acima numa tabela denominada ALUNO com as
    seguintes colunas RA,NOME,A1,A2,A3,A4,MEDIA,RESULTADO
  
  */
  
  DECLARE
  
    /*CALCULAR MEDIA*/
    PROCEDURE INSERIRNOTASALUNO(RA NUMBER, NOME VARCHAR2,N1 NUMBER,N2 NUMBER,N3 NUMBER,N4 NUMBER) IS
      
      VMAIOR NUMBER;
      VMEDIA NUMBER;
      VRESULTADO VARCHAR(20);
      
    BEGIN
     /*MAIOR NOTA*/
      IF(N1>N2) THEN
        VMAIOR := N1;
      ELSE
        VMAIOR := N2;
      END IF;
      
      /*CALCULO DA MEDIA*/
      VMEDIA := (VMAIOR+(N3+N4))/3;
      
      /*DETERMINAR A NOTA*/
      IF VMEDIA < 6 THEN    
          VRESULTADO := 'REPROVADO';
      ELSE 
          VRESULTADO := 'APROVADO';
      END IF; 
      /* INSERT */
      INSERT INTO ALUNO VALUES (RA,NOME,N1,N2,N3,N4,VRESULTADO,VMEDIA);
      COMMIT;
    END; 
  
--Calcular a média somente dos alunos sem média

   PROCEDURE CALCULARMEDIA IS
   
   CURSOR TALUNO IS
    SELECT * FROM ALUNO;
   TA ALUNO%rowtype;
    
   BEGIN
      FOR TA IN TALUNO LOOP  
        IF(ALUNO.MEDIA IS NULL) THEN     
          UPDATE ALUNO 
              SET ALUNO.MEDIA = (ALUNO.NOTA1+ALUNO.NOTA2+ALUNO.NOTA3+ALUNO.NOTA4)/4 
            WHERE ALUNO.RA=TA.RA;
          END IF;     
      END LOOP;
    
   END;
  
  BEGIN
  
  --inserir novos alunos e calcular a media com as notas 
    INSERIRNOTASALUNO(7,'XUXA',10,3,4,8); 
    
  --calcular a media dos alunos existentes
    CALCULARMEDIA;
   
  END;
  
  