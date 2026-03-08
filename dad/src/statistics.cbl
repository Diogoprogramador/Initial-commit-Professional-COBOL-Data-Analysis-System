IDENTIFICATION DIVISION.
       PROGRAM-ID. STATISTICS.
       AUTHOR. SEU NOME.
       DATE-WRITTEN. TODAY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-DATA-ARRAY.
           05 DATA-VALUES OCCURS 100 TIMES.
               10 SALARY-VALUE    PIC 9(6)V99.
               10 AGE-VALUE       PIC 99.
               10 DEPT-CODE       PIC X(3).
       
       01 WS-COUNTERS.
           05 DATA-COUNT      PIC 999 VALUE 0.
           05 LOOP-COUNTER    PIC 999.
           05 TEMP-COUNTER     PIC 999.
       
       01 WS-CALCULATIONS.
           05 SUM-SALARY      PIC 9(8)V99.
           05 SUM-AGE         PIC 999.
           05 MEAN-SALARY     PIC 9(6)V99.
           05 MEAN-AGE        PIC 99V99.
           05 MEDIAN-SALARY   PIC 9(6)V99.
           05 MEDIAN-AGE      PIC 99V99.
           05 MODE-SALARY     PIC 9(6)V99.
           05 MODE-AGE        PIC 99.
       
       01 WS-TEMP.
           05 TEMP-SALARY     PIC 9(6)V99.
           05 TEMP-AGE        PIC 99.
           05 SWAP-FLAG       PIC X.
       
       01 WS-DEPT-STATS.
           05 DEPT-COUNTS OCCURS 10 TIMES.
               10 DEPT-NAME     PIC X(15).
               10 DEPT-TOTAL    PIC 999.
               10 DEPT-AVG-SAL  PIC 9(6)V99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZATION
           PERFORM LOAD-SAMPLE-DATA
           PERFORM CALCULATE-MEANS
           PERFORM CALCULATE-MEDIAN
           PERFORM CALCULATE-MODE
           PERFORM DEPARTMENT-ANALYSIS
           PERFORM DISPLAY-RESULTS
           GOBACK.
       
       INITIALIZATION.
           DISPLAY "=== MODULO DE ESTATISTICAS ==="
           INITIALIZE WS-DATA-ARRAY
           INITIALIZE WS-COUNTERS
           INITIALIZE WS-CALCULATIONS.
       
       LOAD-SAMPLE-DATA.
           MOVE 5000.00 TO SALARY-VALUE(1)
           MOVE 35 TO AGE-VALUE(1)
           MOVE "TI" TO DEPT-CODE(1)
           ADD 1 TO DATA-COUNT
           
           MOVE 4500.00 TO SALARY-VALUE(2)
           MOVE 28 TO AGE-VALUE(2)
           MOVE "RH" TO DEPT-CODE(2)
           ADD 1 TO DATA-COUNT
           
           MOVE 6500.00 TO SALARY-VALUE(3)
           MOVE 42 TO AGE-VALUE(3)
           MOVE "FIN" TO DEPT-CODE(3)
           ADD 1 TO DATA-COUNT
           
           MOVE 5200.00 TO SALARY-VALUE(4)
           MOVE 31 TO AGE-VALUE(4)
           MOVE "TI" TO DEPT-CODE(4)
           ADD 1 TO DATA-COUNT
           
           MOVE 5800.00 TO SALARY-VALUE(5)
           MOVE 38 TO AGE-VALUE(5)
           MOVE "MAR" TO DEPT-CODE(5)
           ADD 1 TO DATA-COUNT
           
           MOVE 4200.00 TO SALARY-VALUE(6)
           MOVE 26 TO AGE-VALUE(6)
           MOVE "RH" TO DEPT-CODE(6)
           ADD 1 TO DATA-COUNT
           
           MOVE 7200.00 TO SALARY-VALUE(7)
           MOVE 45 TO AGE-VALUE(7)
           MOVE "FIN" TO DEPT-CODE(7)
           ADD 1 TO DATA-COUNT
           
           MOVE 5500.00 TO SALARY-VALUE(8)
           MOVE 33 TO AGE-VALUE(8)
           MOVE "TI" TO DEPT-CODE(8)
           ADD 1 TO DATA-COUNT.
       
       CALCULATE-MEANS.
           PERFORM VARYING LOOP-COUNTER FROM 1 BY 1 
                   UNTIL LOOP-COUNTER > DATA-COUNT
               ADD SALARY-VALUE(LOOP-COUNTER) TO SUM-SALARY
               ADD AGE-VALUE(LOOP-COUNTER) TO SUM-AGE
           END-PERFORM
           
           COMPUTE MEAN-SALARY = SUM-SALARY / DATA-COUNT
           COMPUTE MEAN-AGE = SUM-AGE / DATA-COUNT.
       
       CALCULATE-MEDIAN.
           PERFORM SORT-SALARIES
           IF DATA-COUNT = ODD
               MOVE SALARY-VALUE((DATA-COUNT + 1) / 2) TO MEDIAN-SALARY
           ELSE
               COMPUTE MEDIAN-SALARY = 
                   (SALARY-VALUE(DATA-COUNT / 2) + 
                    SALARY-VALUE((DATA-COUNT / 2) + 1)) / 2
           END-IF.
       
       SORT-SALARIES.
           PERFORM VARYING LOOP-COUNTER FROM 1 BY 1 
                   UNTIL LOOP-COUNTER >= DATA-COUNT
               PERFORM VARYING TEMP-COUNTER FROM LOOP-COUNTER BY 1
                       UNTIL TEMP-COUNTER > DATA-COUNT
                   IF SALARY-VALUE(LOOP-COUNTER) > SALARY-VALUE(TEMP-COUNTER)
                       MOVE SALARY-VALUE(LOOP-COUNTER) TO TEMP-SALARY
                       MOVE SALARY-VALUE(TEMP-COUNTER) TO SALARY-VALUE(LOOP-COUNTER)
                       MOVE TEMP-SALARY TO SALARY-VALUE(TEMP-COUNTER)
                   END-IF
               END-PERFORM
           END-PERFORM.
       
       CALCULATE-MODE.
           MOVE SALARY-VALUE(1) TO MODE-SALARY
           MOVE 1 TO TEMP-COUNTER
           
           PERFORM VARYING LOOP-COUNTER FROM 2 BY 1
                   UNTIL LOOP-COUNTER > DATA-COUNT
               IF SALARY-VALUE(LOOP-COUNTER) = SALARY-VALUE(LOOP-COUNTER - 1)
                   ADD 1 TO TEMP-COUNTER
                   IF TEMP-COUNTER > 1
                       MOVE SALARY-VALUE(LOOP-COUNTER) TO MODE-SALARY
                   END-IF
               ELSE
                   MOVE 1 TO TEMP-COUNTER
               END-IF
           END-PERFORM.
       
       DEPARTMENT-ANALYSIS.
           INITIALIZE WS-DEPT-STATS
           
           PERFORM VARYING LOOP-COUNTER FROM 1 BY 1
                   UNTIL LOOP-COUNTER > DATA-COUNT
               EVALUATE DEPT-CODE(LOOP-COUNTER)
                   WHEN "TI"
                       PERFORM UPDATE-DEPT-STATS(1)
                   WHEN "RH"
                       PERFORM UPDATE-DEPT-STATS(2)
                   WHEN "FIN"
                       PERFORM UPDATE-DEPT-STATS(3)
                   WHEN "MAR"
                       PERFORM UPDATE-DEPT-STATS(4)
               END-EVALUATE
           END-PERFORM.
       
       UPDATE-DEPT-STATS.
           MOVE "TECNOLOGIA" TO DEPT-NAME(1)
           MOVE "RECURSOS HUMANOS" TO DEPT-NAME(2)
           MOVE "FINANCEIRO" TO DEPT-NAME(3)
           MOVE "MARKETING" TO DEPT-NAME(4)
           
           ADD 1 TO DEPT-TOTAL(PARAMETER-1)
           ADD SALARY-VALUE(LOOP-COUNTER) TO DEPT-AVG-SAL(PARAMETER-1).
       
       DISPLAY-RESULTS.
           DISPLAY " "
           DISPLAY "=== RESULTADOS ESTATISTICOS ==="
           DISPLAY "Total de registros analisados: " DATA-COUNT
           DISPLAY " "
           DISPLAY "--- ESTATISTICAS SALARIAIS ---"
           DISPLAY "Media salarial: R$" MEAN-SALARY
           DISPLAY "Mediana salarial: R$" MEDIAN-SALARY
           DISPLAY "Moda salarial: R$" MODE-SALARY
           DISPLAY " "
           DISPLAY "--- ESTATISTICAS DE IDADE ---"
           DISPLAY "Media de idade: " MEAN-AGE " anos"
           DISPLAY " "
           DISPLAY "--- ANALISE POR DEPARTAMENTO ---"
           PERFORM VARYING LOOP-COUNTER FROM 1 BY 1
                   UNTIL LOOP-COUNTER > 4
               IF DEPT-TOTAL(LOOP-COUNTER) > 0
                   COMPUTE DEPT-AVG-SAL(LOOP-COUNTER) = 
                       DEPT-AVG-SAL(LOOP-COUNTER) / DEPT-TOTAL(LOOP-COUNTER)
                   DISPLAY DEPT-NAME(LOOP-COUNTER) ": " 
                           DEPT-TOTAL(LOOP-COUNTER) 
                           " funcionarios, Media: R$" DEPT-AVG-SAL(LOOP-COUNTER)
               END-IF
           END-PERFORM.
