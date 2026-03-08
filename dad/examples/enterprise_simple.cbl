IDENTIFICATION DIVISION.
       PROGRAM-ID. ENTERPRISE-SIMPLE.
       AUTHOR. ENTERPRISE SYSTEMS.
       DATE-WRITTEN. TODAY.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMP-FILE ASSIGN TO "data/enterprise.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
       
       DATA DIVISION.
       FILE SECTION.
       FD EMP-FILE.
       01 EMP-RECORD.
           05 EMP-ID          PIC X(6).
           05 FILLER         PIC X.
           05 EMP-NAME        PIC X(30).
           05 FILLER         PIC X.
           05 EMP-AGE         PIC 99.
           05 FILLER         PIC X.
           05 EMP-SALARY      PIC 9(8)V99.
           05 FILLER         PIC X.
           05 EMP-DEPT        PIC X(20).
           05 FILLER         PIC X.
           05 EMP-DATE        PIC 99999999.
           05 FILLER         PIC X.
           05 EMP-STATUS      PIC X.
       
       WORKING-STORAGE SECTION.
       01 WS-FLAGS.
           05 EOF-FLAG        PIC X VALUE "N".
           05 ERROR-FLAG      PIC X VALUE "N".
       
       01 WS-COUNTERS.
           05 TOTAL-EMP       PIC 999 VALUE 0.
           05 ACTIVE-EMP      PIC 999 VALUE 0.
           05 TOTAL-SALARY    PIC 9(12)V99 VALUE 0.
           05 TOTAL-AGE       PIC 9999 VALUE 0.
       
       01 WS-STATS.
           05 AVG-SALARY      PIC 9(8)V99.
           05 AVG-AGE         PIC 99V99.
           05 MAX-SALARY      PIC 9(8)V99.
           05 MIN-SALARY      PIC 9(8)V99.
       
       01 WS-DEPT-TABLE.
           05 DEPT-STATS OCCURS 5 TIMES.
               10 DEPT-NAME    PIC X(20).
               10 DEPT-COUNT   PIC 999.
               10 DEPT-TOTAL   PIC 9(10)V99.
       
       01 WS-TEMP.
           05 TEMP-SALARY     PIC 9(8)V99.
           05 TEMP-AGE        PIC 99.
           05 TEMP-DEPT       PIC X(20).
           05 DEPT-INDEX      PIC 9.
           05 TEMP-PERCENT    PIC 99V99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM PROCESS-DATA
           PERFORM CALCULATE-STATISTICS
           PERFORM ANALYZE-DEPARTMENTS
           PERFORM DISPLAY-RESULTS
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== ENTERPRISE DATA ANALYSIS ==="
           DISPLAY "Sistema Corporativo de Analise"
           DISPLAY " "
           
           INITIALIZE WS-DEPT-TABLE
           MOVE "TECNOLOGIA" TO DEPT-NAME(1)
           MOVE "RECURSOS HUMANOS" TO DEPT-NAME(2)
           MOVE "FINANCEIRO" TO DEPT-NAME(3)
           MOVE "MARKETING" TO DEPT-NAME(4)
           MOVE "DIRETORIA" TO DEPT-NAME(5)
           
           OPEN INPUT EMP-FILE.
       
       PROCESS-DATA.
           DISPLAY "Processando dados corporativos..."
           
           PERFORM UNTIL EOF-FLAG = "Y"
               READ EMP-FILE
                   AT END MOVE "Y" TO EOF-FLAG
                   NOT AT END
                       PERFORM PROCESS-EMPLOYEE
               END-READ
           END-PERFORM
           
           CLOSE EMP-FILE.
           DISPLAY "Total de registros: " TOTAL-EMP.
       
       PROCESS-EMPLOYEE.
           ADD 1 TO TOTAL-EMP
           MOVE EMP-AGE TO TEMP-AGE
           MOVE EMP-SALARY TO TEMP-SALARY
           MOVE EMP-DEPT TO TEMP-DEPT
           
           ADD TEMP-AGE TO TOTAL-AGE
           ADD TEMP-SALARY TO TOTAL-SALARY
           
           IF EMP-STATUS = "A"
               ADD 1 TO ACTIVE-EMP
           END-IF
           
           IF TOTAL-EMP = 1
               MOVE TEMP-SALARY TO MAX-SALARY
               MOVE TEMP-SALARY TO MIN-SALARY
           ELSE
               IF TEMP-SALARY > MAX-SALARY
                   MOVE TEMP-SALARY TO MAX-SALARY
               END-IF
               IF TEMP-SALARY < MIN-SALARY
                   MOVE TEMP-SALARY TO MIN-SALARY
               END-IF
           END-IF
           
           PERFORM UPDATE-DEPARTMENT.
       
       UPDATE-DEPARTMENT.
           PERFORM VARYING DEPT-INDEX FROM 1 BY 1
                   UNTIL DEPT-INDEX > 5
               IF DEPT-NAME(DEPT-INDEX) = TEMP-DEPT
                   ADD 1 TO DEPT-COUNT(DEPT-INDEX)
                   ADD TEMP-SALARY TO DEPT-TOTAL(DEPT-INDEX)
                   EXIT PERFORM
               END-IF
           END-PERFORM.
       
       CALCULATE-STATISTICS.
           IF TOTAL-EMP > 0
               COMPUTE AVG-SALARY = TOTAL-SALARY / TOTAL-EMP
               COMPUTE AVG-AGE = TOTAL-AGE / TOTAL-EMP
           END-IF.
       
       ANALYZE-DEPARTMENTS.
           PERFORM VARYING DEPT-INDEX FROM 1 BY 1
                   UNTIL DEPT-INDEX > 5
               IF DEPT-COUNT(DEPT-INDEX) > 0
                   COMPUTE TEMP-SALARY = DEPT-TOTAL(DEPT-INDEX) / DEPT-COUNT(DEPT-INDEX)
                   MOVE TEMP-SALARY TO DEPT-TOTAL(DEPT-INDEX)
               END-IF
           END-PERFORM.
       
       DISPLAY-RESULTS.
           DISPLAY " "
           DISPLAY "=== RESULTADOS CORPORATIVOS ==="
           DISPLAY "Total de Funcionarios: " TOTAL-EMP
           DISPLAY "Funcionarios Ativos: " ACTIVE-EMP
           COMPUTE TEMP-PERCENT = ACTIVE-EMP * 100 / TOTAL-EMP
           DISPLAY "Taxa de Atividade: " TEMP-PERCENT "%"
           DISPLAY " "
           DISPLAY "--- ESTATISTICAS GERAIS ---"
           DISPLAY "Idade Media: " AVG-AGE " anos"
           DISPLAY "Salario Medio: R$" AVG-SALARY
           DISPLAY "Maior Salario: R$" MAX-SALARY
           DISPLAY "Menor Salario: R$" MIN-SALARY
           DISPLAY " "
           DISPLAY "--- ANALISE POR DEPARTAMENTO ---"
           PERFORM VARYING DEPT-INDEX FROM 1 BY 1
                   UNTIL DEPT-INDEX > 5
               IF DEPT-COUNT(DEPT-INDEX) > 0
                   DISPLAY DEPT-NAME(DEPT-INDEX) ": "
                           DEPT-COUNT(DEPT-INDEX) " funcionarios, "
                           "Media salarial: R$" DEPT-TOTAL(DEPT-INDEX)
               END-IF
           END-PERFORM
           DISPLAY " "
           DISPLAY "=== ANALISE CONCLUIDA ===".
