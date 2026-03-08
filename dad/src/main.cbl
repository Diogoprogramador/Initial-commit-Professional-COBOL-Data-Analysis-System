IDENTIFICATION DIVISION.
       PROGRAM-ID. DATA-ANALYSIS.
       AUTHOR. SEU NOME.
       DATE-WRITTEN. TODAY.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT DATA-FILE ASSIGN TO "../data/input.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT REPORT-FILE ASSIGN TO "../data/output.rpt"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD DATA-FILE.
       01 DATA-RECORD.
           05 EMP-ID         PIC X(3).
           05 FILLER         PIC X.
           05 EMP-NOME       PIC X(20).
           05 FILLER         PIC X.
           05 EMP-IDADE      PIC 99.
           05 FILLER         PIC X.
           05 EMP-SALARIO    PIC 9(5)V99.
           05 FILLER         PIC X.
           05 EMP-DEPT       PIC X(15).
       
       FD REPORT-FILE.
       01 REPORT-RECORD     PIC X(80).
       
       WORKING-STORAGE SECTION.
       01 WS-FLAGS.
           05 EOF-FLAG       PIC X VALUE "N".
           05 ERROR-FLAG     PIC X VALUE "N".
       
       01 WS-COUNTERS.
           05 TOTAL-REGISTROS PIC 999 VALUE 0.
           05 TOTAL-IDADE     PIC 999 VALUE 0.
           05 TOTAL-SALARIO   PIC 9(8)V99 VALUE 0.
       
       01 WS-STATISTICS.
           05 MEDIA-IDADE     PIC 99V99.
           05 MEDIA-SALARIO   PIC 9(6)V99.
           05 MAIOR-SALARIO   PIC 9(6)V99.
           05 MENOR-SALARIO   PIC 9(6)V99.
       
       01 WS-TEMP.
           05 TEMP-SALARIO    PIC 9(6)V99.
           05 TEMP-IDADE      PIC 99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM PROCESS-DATA
           PERFORM CALCULATE-STATISTICS
           PERFORM GENERATE-REPORT
           PERFORM CLEANUP
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== SISTEMA DE ANALISE DE DADOS ==="
           DISPLAY "Iniciando processamento..."
           OPEN INPUT DATA-FILE
           IF DATA-FILE STATUS NOT = "00"
               MOVE "Y" TO ERROR-FLAG
               DISPLAY "ERRO: Arquivo de dados nao encontrado"
               GOBACK
           END-IF.
       
       PROCESS-DATA.
           PERFORM UNTIL EOF-FLAG = "Y"
               READ DATA-FILE INTO DATA-RECORD
                   AT END MOVE "Y" TO EOF-FLAG
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM.
           CLOSE DATA-FILE.
           DISPLAY "Total de registros processados: " TOTAL-REGISTROS.
       
       PROCESS-RECORD.
           ADD 1 TO TOTAL-REGISTROS
           MOVE EMP-IDADE TO TEMP-IDADE
           MOVE EMP-SALARIO TO TEMP-SALARIO
           ADD TEMP-IDADE TO TOTAL-IDADE
           ADD TEMP-SALARIO TO TOTAL-SALARIO
           
           IF TOTAL-REGISTROS = 1
               MOVE TEMP-SALARIO TO MAIOR-SALARIO
               MOVE TEMP-SALARIO TO MENOR-SALARIO
           ELSE
               IF TEMP-SALARIO > MAIOR-SALARIO
                   MOVE TEMP-SALARIO TO MAIOR-SALARIO
               END-IF
               IF TEMP-SALARIO < MENOR-SALARIO
                   MOVE TEMP-SALARIO TO MENOR-SALARIO
               END-IF
           END-IF.
       
       CALCULATE-STATISTICS.
           IF TOTAL-REGISTROS > 0
               COMPUTE MEDIA-IDADE = TOTAL-IDADE / TOTAL-REGISTROS
               COMPUTE MEDIA-SALARIO = TOTAL-SALARIO / TOTAL-REGISTROS
           END-IF.
       
       GENERATE-REPORT.
           OPEN OUTPUT REPORT-FILE
           IF REPORT-FILE STATUS = "00"
               PERFORM WRITE-REPORT-HEADER
               PERFORM WRITE-REPORT-DATA
               PERFORM WRITE-REPORT-FOOTER
               CLOSE REPORT-FILE
               DISPLAY "Relatorio gerado com sucesso!"
           ELSE
               DISPLAY "ERRO: Nao foi possivel criar o relatorio"
           END-IF.
       
       WRITE-REPORT-HEADER.
           MOVE "RELATORIO DE ANALISE DE DADOS" TO REPORT-RECORD
           WRITE REPORT-RECORD
           MOVE "================================" TO REPORT-RECORD
           WRITE REPORT-RECORD
           MOVE SPACE TO REPORT-RECORD
           WRITE REPORT-RECORD.
       
       WRITE-REPORT-DATA.
           STRING "Total de Registros: " DELIMITED BY SIZE
                  TOTAL-REGISTROS DELIMITED BY SIZE
                  INTO REPORT-RECORD
           WRITE REPORT-RECORD
           
           STRING "Media de Idade: " DELIMITED BY SIZE
                  MEDIA-IDADE DELIMITED BY SIZE
                  " anos" DELIMITED BY SIZE
                  INTO REPORT-RECORD
           WRITE REPORT-RECORD
           
           STRING "Media Salarial: R$ " DELIMITED BY SIZE
                  MEDIA-SALARIO DELIMITED BY SIZE
                  INTO REPORT-RECORD
           WRITE REPORT-RECORD
           
           STRING "Maior Salario: R$ " DELIMITED BY SIZE
                  MAIOR-SALARIO DELIMITED BY SIZE
                  INTO REPORT-RECORD
           WRITE REPORT-RECORD
           
           STRING "Menor Salario: R$ " DELIMITED BY SIZE
                  MENOR-SALARIO DELIMITED BY SIZE
                  INTO REPORT-RECORD
           WRITE REPORT-RECORD.
       
       WRITE-REPORT-FOOTER.
           MOVE SPACE TO REPORT-RECORD
           WRITE REPORT-RECORD
           MOVE "=== FIM DO RELATORIO ===" TO REPORT-RECORD
           WRITE REPORT-RECORD.
       
       CLEANUP.
           DISPLAY "Processamento concluido."
           DISPLAY "Verifique o arquivo output.rpt para resultados."
