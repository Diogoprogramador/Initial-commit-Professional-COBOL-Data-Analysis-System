IDENTIFICATION DIVISION.
       PROGRAM-ID. REPORT-GENERATOR.
       AUTHOR. SEU NOME.
       DATE-WRITTEN. TODAY.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT REPORT-FILE ASSIGN TO "report.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT CSV-FILE ASSIGN TO "report.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD REPORT-FILE.
       01 REPORT-LINE       PIC X(80).
       
       FD CSV-FILE.
       01 CSV-LINE          PIC X(120).
       
       WORKING-STORAGE SECTION.
       01 WS-HEADERS.
           05 TITLE-1        PIC X(80) VALUE 
                   "RELATORIO DE ANALISE DE DADOS - EMPRESA ABC".
           05 TITLE-2        PIC X(80) VALUE 
                   "GERADO EM: ".
           05 SEPARATOR      PIC X(80) VALUE 
                   "================================================================".
           05 HEADER-TABLE   PIC X(80) VALUE 
                   "ID    NOME                IDADE  SALARIO    DEPARTAMENTO".
       
       01 WS-REPORT-DATA.
           05 EMP-ID         PIC X(3).
           05 EMP-NOME       PIC X(20).
           05 EMP-IDADE      PIC 99.
           05 EMP-SALARIO    PIC 9(6)V99.
           05 EMP-DEPT       PIC X(15).
       
       01 WS-COUNTERS.
           05 LINE-COUNT     PIC 999 VALUE 0.
           05 PAGE-COUNT     PIC 99 VALUE 1.
           05 RECORD-COUNT   PIC 999 VALUE 0.
       
       01 WS-TOTALS.
           05 TOTAL-SALARY   PIC 9(8)V99.
           05 AVG-SALARY     PIC 9(6)V99.
           05 MAX-SALARY     PIC 9(6)V99.
           05 MIN-SALARY     PIC 9(6)V99.
           05 TOTAL-EMPLOYEES PIC 999.
       
       01 WS-DATE-TIME.
           05 CURRENT-DATE.
               10 YEAR        PIC 9999.
               10 MONTH       PIC 99.
               10 DAY         PIC 99.
           05 CURRENT-TIME.
               10 HOUR        PIC 99.
               10 MINUTE      PIC 99.
               10 SECOND      PIC 99.
       
       01 WS-FORMATS.
           05 FORMATTED-SALARY PIC Z(5)9.99.
           05 FORMATTED-DATE  PIC 99/99/9999.
           05 FORMATTED-TIME  PIC 99:99:99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM GENERATE-TEXT-REPORT
           PERFORM GENERATE-CSV-REPORT
           PERFORM DISPLAY-SUMMARY
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== GERADOR DE RELATORIOS ==="
           ACCEPT CURRENT-DATE FROM DATE
           ACCEPT CURRENT-TIME FROM TIME
           INITIALIZE WS-TOTALS
           OPEN OUTPUT REPORT-FILE
           OPEN OUTPUT CSV-FILE
           IF REPORT-FILE STATUS NOT = "00" OR CSV-FILE STATUS NOT = "00"
               DISPLAY "ERRO: Nao foi possivel criar arquivos de relatorio"
               GOBACK
           END-IF.
       
       GENERATE-TEXT-REPORT.
           PERFORM WRITE-REPORT-HEADER
           PERFORM WRITE-REPORT-BODY
           PERFORM WRITE-REPORT-FOOTER
           CLOSE REPORT-FILE.
       
       WRITE-REPORT-HEADER.
           WRITE REPORT-LINE FROM SEPARATOR
           WRITE REPORT-LINE FROM TITLE-1
           WRITE REPORT-LINE FROM TITLE-2
           MOVE YEAR TO FORMATTED-DATE(7:4)
           MOVE MONTH TO FORMATTED-DATE(1:2)
           MOVE DAY TO FORMATTED-DATE(4:2)
           STRING "DATA: " FORMATTED-DATE DELIMITED BY SIZE
                  INTO REPORT-LINE
           WRITE REPORT-LINE
           MOVE HOUR TO FORMATTED-TIME(1:2)
           MOVE MINUTE TO FORMATTED-TIME(4:2)
           MOVE SECOND TO FORMATTED-TIME(7:2)
           STRING "HORA: " FORMATTED-TIME DELIMITED BY SIZE
                  INTO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE FROM SEPARATOR
           WRITE REPORT-LINE FROM HEADER-TABLE
           WRITE REPORT-LINE FROM SEPARATOR.
       
       WRITE-REPORT-BODY.
           PERFORM LOAD-SAMPLE-RECORDS
           PERFORM VARYING LINE-COUNT FROM 1 BY 1
                   UNTIL LINE-COUNT > RECORD-COUNT
               PERFORM WRITE-EMPLOYEE-RECORD
           END-PERFORM.
       
       LOAD-SAMPLE-RECORDS.
           MOVE "001" TO EMP-ID
           MOVE "JOAO SILVA" TO EMP-NOME
           MOVE 35 TO EMP-IDADE
           MOVE 5000.00 TO EMP-SALARIO
           MOVE "TECNOLOGIA" TO EMP-DEPT
           ADD 1 TO RECORD-COUNT
           ADD EMP-SALARIO TO TOTAL-SALARY
           IF RECORD-COUNT = 1
               MOVE EMP-SALARIO TO MAX-SALARY
               MOVE EMP-SALARIO TO MIN-SALARY
           ELSE
               IF EMP-SALARIO > MAX-SALARY
                   MOVE EMP-SALARIO TO MAX-SALARY
               END-IF
               IF EMP-SALARIO < MIN-SALARY
                   MOVE EMP-SALARIO TO MIN-SALARY
               END-IF
           END-IF
           
           MOVE "002" TO EMP-ID
           MOVE "ANA SOUZA" TO EMP-NOME
           MOVE 28 TO EMP-IDADE
           MOVE 4500.00 TO EMP-SALARIO
           MOVE "RECURSOS HUMANOS" TO EMP-DEPT
           ADD 1 TO RECORD-COUNT
           ADD EMP-SALARIO TO TOTAL-SALARY
           IF EMP-SALARIO > MAX-SALARY
               MOVE EMP-SALARIO TO MAX-SALARY
           END-IF
           IF EMP-SALARIO < MIN-SALARY
               MOVE EMP-SALARIO TO MIN-SALARY
           END-IF
           
           MOVE "003" TO EMP-ID
           MOVE "CARLOS SANTOS" TO EMP-NOME
           MOVE 42 TO EMP-IDADE
           MOVE 6500.00 TO EMP-SALARIO
           MOVE "FINANCEIRO" TO EMP-DEPT
           ADD 1 TO RECORD-COUNT
           ADD EMP-SALARIO TO TOTAL-SALARY
           IF EMP-SALARIO > MAX-SALARY
               MOVE EMP-SALARIO TO MAX-SALARY
           END-IF
           IF EMP-SALARIO < MIN-SALARY
               MOVE EMP-SALARIO TO MIN-SALARY
           END-IF.
       
       WRITE-EMPLOYEE-RECORD.
           MOVE EMP-SALARIO TO FORMATTED-SALARY
           STRING EMP-ID DELIMITED BY SIZE
                  "    " DELIMITED BY SIZE
                  EMP-NOME DELIMITED BY SIZE
                  "    " DELIMITED BY SIZE
                  EMP-IDADE DELIMITED BY SIZE
                  "     " DELIMITED BY SIZE
                  FORMATTED-SALARY DELIMITED BY SIZE
                  "    " DELIMITED BY SIZE
                  EMP-DEPT DELIMITED BY SIZE
                  INTO REPORT-LINE
           WRITE REPORT-LINE.
       
       WRITE-REPORT-FOOTER.
           WRITE REPORT-LINE FROM SEPARATOR
           COMPUTE AVG-SALARY = TOTAL-SALARY / RECORD-COUNT
           MOVE TOTAL-SALARY TO FORMATTED-SALARY
           STRING "TOTAL DE FUNCIONARIOS: " RECORD-COUNT 
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           STRING "SOMA SALARIOS: R$ " FORMATTED-SALARY 
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           MOVE AVG-SALARY TO FORMATTED-SALARY
           STRING "MEDIA SALARIAL: R$ " FORMATTED-SALARY 
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           MOVE MAX-SALARY TO FORMATTED-SALARY
           STRING "MAIOR SALARIO: R$ " FORMATTED-SALARY 
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           MOVE MIN-SALARY TO FORMATTED-SALARY
           STRING "MENOR SALARIO: R$ " FORMATTED-SALARY 
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE FROM SEPARATOR.
       
       GENERATE-CSV-REPORT.
           STRING "ID,NOME,IDADE,SALARIO,DEPARTAMENTO" 
                  DELIMITED BY SIZE INTO CSV-LINE
           WRITE CSV-LINE
           
           PERFORM VARYING LINE-COUNT FROM 1 BY 1
                   UNTIL LINE-COUNT > RECORD-COUNT
               PERFORM WRITE-CSV-RECORD
           END-PERFORM
           CLOSE CSV-FILE.
       
       WRITE-CSV-RECORD.
           STRING EMP-ID DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  EMP-NOME DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  EMP-IDADE DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  EMP-SALARIO DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  EMP-DEPT DELIMITED BY SIZE
                  INTO CSV-LINE
           WRITE CSV-LINE.
       
       DISPLAY-SUMMARY.
           DISPLAY " "
           DISPLAY "=== RELATORIOS GERADOS COM SUCESSO ==="
           DISPLAY "Arquivo texto: report.txt"
           DISPLAY "Arquivo CSV: report.csv"
           DISPLAY "Total de registros: " RECORD-COUNT
           DISPLAY "Relatorio gerado em: " FORMATTED-DATE 
                   " as " FORMATTED-TIME.
