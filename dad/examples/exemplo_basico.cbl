IDENTIFICATION DIVISION.
       PROGRAM-ID. EXEMPLO-BASICO.
       AUTHOR. SEU NOME.
       DATE-WRITTEN. TODAY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-VARIAVEIS.
           05 NOME-FUNCIONARIO   PIC X(30) VALUE "JOAO SILVA".
           05 SALARIO-FUNC      PIC 9(6)V99 VALUE 5500.00.
           05 IDADE-FUNC        PIC 99 VALUE 35.
           05 DEPARTAMENTO      PIC X(15) VALUE "TECNOLOGIA".
           05 SALARIO-FORMATADO PIC Z(5)9.99.
           05 PERCENTUAL-AUMENTO PIC 99V99 VALUE 10.00.
           05 NOVO-SALARIO      PIC 9(6)V99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "=== EXEMPLO BASICO COBOL ==="
           DISPLAY " "
           
           DISPLAY "Dados do Funcionario:"
           DISPLAY "Nome: " NOME-FUNCIONARIO
           DISPLAY "Idade: " IDADE-FUNC " anos"
           DISPLAY "Departamento: " DEPARTAMENTO
           
           MOVE SALARIO-FUNC TO SALARIO-FORMATADO
           DISPLAY "Salario Atual: R$ " SALARIO-FORMATADO
           
           COMPUTE NOVO-SALARIO = SALARIO-FUNC * (1 + PERCENTUAL-AUMENTO / 100)
           MOVE NOVO-SALARIO TO SALARIO-FORMATADO
           DISPLAY "Novo Salario (+10%): R$ " SALARIO-FORMATADO
           
           DISPLAY " "
           DISPLAY "=== FIM DO EXEMPLO ==="
           GOBACK.
