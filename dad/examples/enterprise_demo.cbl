IDENTIFICATION DIVISION.
       PROGRAM-ID. ENTERPRISE-DEMO.
       AUTHOR. ENTERPRISE SYSTEMS ARCHITECT.
       DATE-WRITTEN. TODAY.
       
       REMARKS.
           DEMONSTRACAO EMPRESARIAL AVANCADA
           Sistema de analise de dados para RH/Financeiro
           Com processamento estatistico e relatorios corporativos
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE ASSIGN TO "../data/enterprise.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.
           
           SELECT REPORT-FILE ASSIGN TO "../data/enterprise_report.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-REPORT-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD EMPLOYEE-FILE.
       01 EMPLOYEE-RECORD.
           05 EMP-ID              PIC X(6).
           05 EMP-NAME            PIC X(30).
           05 EMP-AGE             PIC 99.
           05 EMP-SALARY          PIC 9(8)V99.
           05 EMP-DEPARTMENT      PIC X(20).
           05 EMP-HIRE-DATE.
               10 HIRE-YEAR       PIC 9999.
               10 HIRE-MONTH      PIC 99.
               10 HIRE-DAY        PIC 99.
           05 EMP-STATUS          PIC X.
               88 ACTIVE-EMPLOYEE VALUE "A".
               88 INACTIVE-EMPLOYEE VALUE "I".
       
       FD REPORT-FILE.
       01 REPORT-LINE            PIC X(132).
       
       WORKING-STORAGE SECTION.
       01 WS-CONTROL-FIELDS.
           05 WS-EOF-FLAG         PIC X VALUE "N".
               88 END-OF-FILE    VALUE "Y".
           05 WS-FILE-STATUS      PIC XX.
           05 WS-REPORT-STATUS    PIC XX.
           05 WS-ERROR-COUNT      PIC 999 VALUE 0.
           05 WS-VALID-COUNT      PIC 999 VALUE 0.
       
       01 WS-COUNTERS.
           05 WS-TOTAL-EMPLOYEES  PIC 999 VALUE 0.
           05 WS-ACTIVE-EMPLOYEES PIC 999 VALUE 0.
           05 WS-TOTAL-SALARY    PIC 9(12)V99 VALUE 0.
           05 WS-TOTAL-AGE       PIC 9999 VALUE 0.
       
       01 WS-STATISTICS.
           05 WS-AVG-SALARY      PIC 9(8)V99.
           05 WS-AVG-AGE         PIC 99V99.
           05 WS-MAX-SALARY      PIC 9(8)V99.
           05 WS-MIN-SALARY      PIC 9(8)V99.
           05 WS-MEDIAN-SALARY   PIC 9(8)V99.
       
       01 WS-DEPARTMENT-STATS OCCURS 10 TIMES.
           05 WS-DEPT-NAME       PIC X(20).
           05 WS-DEPT-COUNT      PIC 999.
           05 WS-DEPT-TOTAL-SAL  PIC 9(10)V99.
           05 WS-DEPT-AVG-SAL    PIC 9(8)V99.
       
       01 WS-SALARY-DISTRIBUTION.
           05 WS-RANGE-1K        PIC 999 VALUE 0.  * < 2K
           05 WS-RANGE-2K        PIC 999 VALUE 0.  * 2K-4K
           05 WS-RANGE-3K        PIC 999 VALUE 0.  * 4K-6K
           05 WS-RANGE-4K        PIC 999 VALUE 0.  * 6K-8K
           05 WS-RANGE-5K        PIC 999 VALUE 0.  * > 8K
       
       01 WS-FORMATTED-FIELDS.
           05 WS-FORMATTED-SALARY PIC ZZZ.ZZZ.ZZ9,99.
           05 WS-FORMATTED-DATE  PIC 99/99/9999.
           05 WS-FORMATTED-PERC  PIC Z9,99.
       
       01 WS-CURRENT-DATE.
           05 WS-YEAR            PIC 9999.
           05 WS-MONTH           PIC 99.
           05 WS-DAY             PIC 99.
       
       01 WS-CURRENT-TIME.
           05 WS-HOUR            PIC 99.
           05 WS-MINUTE          PIC 99.
           05 WS-SECOND          PIC 99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM PROCESS-EMPLOYEE-DATA
           PERFORM CALCULATE-STATISTICS
           PERFORM ANALYZE-DEPARTMENTS
           PERFORM DISTRIBUTE-SALARIES
           PERFORM GENERATE-ENTERPRISE-REPORT
           PERFORM CLEANUP
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== ENTERPRISE DATA ANALYSIS SYSTEM ==="
           DISPLAY "Sistema Corporativo de Analise de Dados"
           DISPLAY " "
           
           ACCEPT WS-CURRENT-DATE FROM DATE
           ACCEPT WS-CURRENT-TIME FROM TIME
           
           INITIALIZE WS-DEPARTMENT-STATS
           INITIALIZE WS-SALARY-DISTRIBUTION
           
           OPEN INPUT EMPLOYEE-FILE
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "ERRO CRITICO: Arquivo de dados nao encontrado"
               DISPLAY "FILE STATUS: " WS-FILE-STATUS
               GOBACK
           END-IF.
       
       PROCESS-EMPLOYEE-DATA.
           DISPLAY "Processando dados dos funcionarios..."
           
           PERFORM UNTIL END-OF-FILE
               READ EMPLOYEE-FILE
                   AT END SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM VALIDATE-EMPLOYEE-RECORD
                       IF WS-FILE-STATUS = "00"
                           PERFORM PROCESS-VALID-RECORD
                       ELSE
                           ADD 1 TO WS-ERROR-COUNT
                       END-IF
               END-READ
           END-PERFORM
           
           CLOSE EMPLOYEE-FILE.
           
           DISPLAY "Processamento concluido:"
           DISPLAY "  Total de registros: " WS-TOTAL-EMPLOYEES
           DISPLAY "  Registros validos: " WS-VALID-COUNT
           DISPLAY "  Erros encontrados: " WS-ERROR-COUNT.
       
       VALIDATE-EMPLOYEE-RECORD.
           IF EMP-AGE < 18 OR EMP-AGE > 70
               MOVE "10" TO WS-FILE-STATUS
           ELSE IF EMP-SALARY < 1000.00 OR EMP-SALARY > 50000.00
               MOVE "20" TO WS-FILE-STATUS
           ELSE IF EMP-DEPARTMENT = SPACES
               MOVE "30" TO WS-FILE-STATUS
           ELSE
               MOVE "00" TO WS-FILE-STATUS
           END-IF.
       
       PROCESS-VALID-RECORD.
           ADD 1 TO WS-TOTAL-EMPLOYEES
           ADD 1 TO WS-VALID-COUNT
           
           IF ACTIVE-EMPLOYEE
               ADD 1 TO WS-ACTIVE-EMPLOYEES
           END-IF
           
           ADD EMP-AGE TO WS-TOTAL-AGE
           ADD EMP-SALARY TO WS-TOTAL-SALARY
           
           IF WS-TOTAL-EMPLOYEES = 1
               MOVE EMP-SALARY TO WS-MAX-SALARY
               MOVE EMP-SALARY TO WS-MIN-SALARY
           ELSE
               IF EMP-SALARY > WS-MAX-SALARY
                   MOVE EMP-SALARY TO WS-MAX-SALARY
               END-IF
               IF EMP-SALARY < WS-MIN-SALARY
                   MOVE EMP-SALARY TO WS-MIN-SALARY
               END-IF
           END-IF.
       
       CALCULATE-STATISTICS.
           IF WS-TOTAL-EMPLOYEES > 0
               COMPUTE WS-AVG-SALARY = WS-TOTAL-SALARY / WS-TOTAL-EMPLOYEES
               COMPUTE WS-AVG-AGE = WS-TOTAL-AGE / WS-TOTAL-EMPLOYEES
           END-IF.
       
       ANALYZE-DEPARTMENTS.
           DISPLAY "Analisando distribuicao por departamento..."
           
           OPEN INPUT EMPLOYEE-FILE
           PERFORM UNTIL END-OF-FILE
               READ EMPLOYEE-FILE
                   AT END SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM UPDATE-DEPARTMENT-STATS
               END-READ
           END-PERFORM
           CLOSE EMPLOYEE-FILE.
           
           SET END-OF-FILE TO FALSE.
       
       UPDATE-DEPARTMENT-STATS.
           PERFORM VARYING WS-DEPT-INDEX FROM 1 BY 1
                   UNTIL WS-DEPT-INDEX > 10
               IF WS-DEPT-NAME(WS-DEPT-INDEX) = EMP-DEPARTMENT
                   ADD 1 TO WS-DEPT-COUNT(WS-DEPT-INDEX)
                   ADD EMP-SALARY TO WS-DEPT-TOTAL-SAL(WS-DEPT-INDEX)
                   EXIT PERFORM
               END-IF
               IF WS-DEPT-NAME(WS-DEPT-INDEX) = SPACES
                   MOVE EMP-DEPARTMENT TO WS-DEPT-NAME(WS-DEPT-INDEX)
                   ADD 1 TO WS-DEPT-COUNT(WS-DEPT-INDEX)
                   ADD EMP-SALARY TO WS-DEPT-TOTAL-SAL(WS-DEPT-INDEX)
                   EXIT PERFORM
               END-IF
           END-PERFORM.
       
       DISTRIBUTE-SALARIES.
           OPEN INPUT EMPLOYEE-FILE
           PERFORM UNTIL END-OF-FILE
               READ EMPLOYEE-FILE
                   AT END SET END-OF-FILE TO TRUE
                   NOT AT END
                       PERFORM CLASSIFY-SALARY-RANGE
               END-READ
           END-PERFORM
           CLOSE EMPLOYEE-FILE.
           
           SET END-OF-FILE TO FALSE.
       
       CLASSIFY-SALARY-RANGE.
           IF EMP-SALARY < 2000.00
               ADD 1 TO WS-RANGE-1K
           ELSE IF EMP-SALARY < 4000.00
               ADD 1 TO WS-RANGE-2K
           ELSE IF EMP-SALARY < 6000.00
               ADD 1 TO WS-RANGE-3K
           ELSE IF EMP-SALARY < 8000.00
               ADD 1 TO WS-RANGE-4K
           ELSE
               ADD 1 TO WS-RANGE-5K
           END-IF.
       
       GENERATE-ENTERPRISE-REPORT.
           DISPLAY "Gerando relatorio corporativo..."
           
           OPEN OUTPUT REPORT-FILE
           IF WS-REPORT-STATUS = "00"
               PERFORM WRITE-REPORT-HEADER
               PERFORM WRITE-EXECUTIVE-SUMMARY
               PERFORM WRITE-STATISTICAL-ANALYSIS
               PERFORM WRITE-DEPARTMENT-ANALYSIS
               PERFORM WRITE-SALARY-DISTRIBUTION
               PERFORM WRITE-REPORT-FOOTER
               CLOSE REPORT-FILE
               DISPLAY "Relatorio gerado: enterprise_report.txt"
           ELSE
               DISPLAY "ERRO: Nao foi possivel gerar relatorio"
           END-IF.
       
       WRITE-REPORT-HEADER.
           MOVE ALL "=" TO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "RELATORIO CORPORATIVO DE ANALISE DE DADOS"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "GERADO EM: " WS-DAY "/" WS-MONTH "/" WS-YEAR
                  " " WS-HOUR ":" WS-MINUTE ":" WS-SECOND
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE ALL "=" TO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE.
       
       WRITE-EXECUTIVE-SUMMARY.
           MOVE "RESUMO EXECUTIVO" TO REPORT-LINE
           WRITE REPORT-LINE
           MOVE ALL "-" TO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "Total de Funcionarios: " WS-TOTAL-EMPLOYEES
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "Funcionarios Ativos: " WS-ACTIVE-EMPLOYEES
                  " (" WS-ACTIVE-EMPLOYEES * 100 / WS-TOTAL-EMPLOYEES "%)"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-TOTAL-SALARY TO WS-FORMATTED-SALARY
           STRING "Massa Salarial Total: R$ " WS-FORMATTED-SALARY
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE.
       
       WRITE-STATISTICAL-ANALYSIS.
           MOVE "ANALISE ESTATISTICA" TO REPORT-LINE
           WRITE REPORT-LINE
           MOVE ALL "-" TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-AVG-SALARY TO WS-FORMATTED-SALARY
           STRING "Salario Medio: R$ " WS-FORMATTED-SALARY
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "Idade Media: " WS-AVG-AGE " anos"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-MAX-SALARY TO WS-FORMATTED-SALARY
           STRING "Maior Salario: R$ " WS-FORMATTED-SALARY
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-MIN-SALARY TO WS-FORMATTED-SALARY
           STRING "Menor Salario: R$ " WS-FORMATTED-SALARY
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE.
       
       WRITE-DEPARTMENT-ANALYSIS.
           MOVE "ANALISE POR DEPARTAMENTO" TO REPORT-LINE
           WRITE REPORT-LINE
           MOVE ALL "-" TO REPORT-LINE
           WRITE REPORT-LINE
           
           PERFORM VARYING WS-DEPT-INDEX FROM 1 BY 1
                   UNTIL WS-DEPT-INDEX > 10
               IF WS-DEPT-COUNT(WS-DEPT-INDEX) > 0
                   COMPUTE WS-DEPT-AVG-SAL(WS-DEPT-INDEX) = 
                       WS-DEPT-TOTAL-SAL(WS-DEPT-INDEX) / 
                       WS-DEPT-COUNT(WS-DEPT-INDEX)
                   
                   MOVE WS-DEPT-AVG-SAL(WS-DEPT-INDEX) TO WS-FORMATTED-SALARY
                   STRING WS-DEPT-NAME(WS-DEPT-INDEX) ": "
                          WS-DEPT-COUNT(WS-DEPT-INDEX) " func, "
                          "Media: R$ " WS-FORMATTED-SALARY
                          DELIMITED BY SIZE INTO REPORT-LINE
                   WRITE REPORT-LINE
               END-IF
           END-PERFORM
           WRITE REPORT-LINE.
       
       WRITE-SALARY-DISTRIBUTION.
           MOVE "DISTRIBUICAO SALARIAL" TO REPORT-LINE
           WRITE REPORT-LINE
           MOVE ALL "-" TO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "< R$ 2.000: " WS-RANGE-1K " funcionarios"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "R$ 2.000-4.000: " WS-RANGE-2K " funcionarios"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "R$ 4.000-6.000: " WS-RANGE-3K " funcionarios"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "R$ 6.000-8.000: " WS-RANGE-4K " funcionarios"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "> R$ 8.000: " WS-RANGE-5K " funcionarios"
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE.
       
       WRITE-REPORT-FOOTER.
           MOVE ALL "=" TO REPORT-LINE
           WRITE REPORT-LINE
           
           STRING "FIM DO RELATORIO - Total de erros: " WS-ERROR-COUNT
                  DELIMITED BY SIZE INTO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE ALL "=" TO REPORT-LINE
           WRITE REPORT-LINE.
       
       CLEANUP.
           DISPLAY " "
           DISPLAY "=== PROCESSAMENTO CONCLUIDO ==="
           DISPLAY "Relatorio corporativo gerado com sucesso!"
           DISPLAY " "
           DISPLAY "Métricas Finais:"
           DISPLAY "  - Eficiencia: " 
                   WS-VALID-COUNT * 100 / WS-TOTAL-EMPLOYEES "%"
           DISPLAY "  - Qualidade dos dados: "
                   (WS-TOTAL-EMPLOYEES - WS-ERROR-COUNT) * 100 / 
                   WS-TOTAL-EMPLOYEES "%"
           DISPLAY " "
           DISPLAY "Sistema pronto para proximo ciclo de processamento."
