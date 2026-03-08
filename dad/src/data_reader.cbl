IDENTIFICATION DIVISION.
       PROGRAM-ID. DATA-READER.
       AUTHOR. SEU NOME.
       DATE-WRITTEN. TODAY.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "input.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD INPUT-FILE.
       01 INPUT-RECORD.
           05 RECORD-ID      PIC X(3).
           05 FILLER         PIC X.
           05 RECORD-NOME    PIC X(20).
           05 FILLER         PIC X.
           05 RECORD-IDADE   PIC 99.
           05 FILLER         PIC X.
           05 RECORD-SALARIO PIC 9(5)V99.
           05 FILLER         PIC X.
           05 RECORD-DEPT    PIC X(15).
       
       WORKING-STORAGE SECTION.
       01 WS-FLAGS.
           05 EOF-FLAG       PIC X VALUE "N".
           05 VALID-FLAG     PIC X VALUE "Y".
       
       01 WS-COUNTERS.
           05 RECORD-COUNT   PIC 999 VALUE 0.
           05 ERROR-COUNT    PIC 999 VALUE 0.
       
       01 WS-CURRENT-RECORD.
           05 EMP-ID         PIC X(3).
           05 EMP-NOME       PIC X(20).
           05 EMP-IDADE      PIC 99.
           05 EMP-SALARIO    PIC 9(5)V99.
           05 EMP-DEPT       PIC X(15).
       
       01 WS-VALIDATION.
           05 AGE-VALID      PIC X.
           05 SALARY-VALID   PIC X.
           05 DEPT-VALID     PIC X.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM READ-ALL-RECORDS
           PERFORM DISPLAY-SUMMARY
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== MODULO DE LEITURA DE DADOS ==="
           OPEN INPUT INPUT-FILE
           IF INPUT-FILE STATUS NOT = "00"
               DISPLAY "ERRO: Arquivo nao encontrado: input.dat"
               GOBACK
           END-IF.
       
       READ-ALL-RECORDS.
           PERFORM UNTIL EOF-FLAG = "Y"
               READ INPUT-FILE INTO INPUT-RECORD
                   AT END MOVE "Y" TO EOF-FLAG
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM
           CLOSE INPUT-FILE.
       
       PROCESS-RECORD.
           ADD 1 TO RECORD-COUNT
           MOVE INPUT-RECORD TO WS-CURRENT-RECORD
           PERFORM VALIDATE-RECORD
           
           IF VALID-FLAG = "Y"
               DISPLAY "Registro [" RECORD-ID "] " RECORD-NOME 
                       " - Idade: " RECORD-IDADE 
                       " - Salario: R$" RECORD-SALARIO
           ELSE
               ADD 1 TO ERROR-COUNT
               DISPLAY "ERRO no registro [" RECORD-ID "]: Dados invalidos"
           END-IF.
       
       VALIDATE-RECORD.
           MOVE "Y" TO VALID-FLAG
           
           IF RECORD-IDADE < 18 OR RECORD-IDADE > 70
               MOVE "N" TO AGE-VALID
               MOVE "N" TO VALID-FLAG
           ELSE
               MOVE "Y" TO AGE-VALID
           END-IF
           
           IF RECORD-SALARIO < 1000.00 OR RECORD-SALARIO > 50000.00
               MOVE "N" TO SALARY-VALID
               MOVE "N" TO VALID-FLAG
           ELSE
               MOVE "Y" TO SALARY-VALID
           END-IF
           
           IF RECORD-DEPT = SPACES
               MOVE "N" TO DEPT-VALID
               MOVE "N" TO VALID-FLAG
           ELSE
               MOVE "Y" TO DEPT-VALID
           END-IF.
       
       DISPLAY-SUMMARY.
           DISPLAY " "
           DISPLAY "=== RESUMO DA LEITURA ==="
           DISPLAY "Total de registros lidos: " RECORD-COUNT
           DISPLAY "Registros validos: " RECORD-COUNT - ERROR-COUNT
           DISPLAY "Registros com erro: " ERROR-COUNT
           DISPLAY "Taxa de sucesso: " 
                   (RECORD-COUNT - ERROR-COUNT) / RECORD-COUNT * 100 "%".
