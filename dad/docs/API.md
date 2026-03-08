# 🔌 API Reference - COBOL Data Analysis System

## 🎯 **Visão Geral**

Referência completa para integração do sistema COBOL Data Analysis com aplicações externas e automação de processos.

## 📋 **Interface de Linha de Comando**

### **Execução Principal**
```bash
# Execução padrão
./bin/data-analysis [opções]

# Opções disponíveis
--input=<arquivo>     # Arquivo de dados de entrada
--output=<arquivo>    # Arquivo de relatório de saída
--format=<tipo>       # Formato: txt|csv|json
--verbose             # Modo verboso
--quiet               # Modo silencioso
--help                # Ajuda
--version             # Versão
```

### **Exemplos de Uso**
```bash
# Processamento básico
./bin/data-analysis --input=data/input.dat --output=report.txt

# Exportação CSV
./bin/data-analysis --input=data/input.dat --output=report.csv --format=csv

# Modo verboso
./bin/data-analysis --input=data/input.dat --verbose

# Batch processing
./bin/data-analysis --batch=data/*.dat
```

## 🔧 **Módulos Programáticos**

### **data_reader.cbl - Engine de Leitura**

#### **Funções Principais**
```cobol
* Inicialização do leitor
CALL "INIT-DATA-READER" USING WS-CONFIG
    RETURNING WS-STATUS

* Leitura de registro
CALL "READ-RECORD" USING DATA-RECORD
    RETURNING READ-STATUS

* Validação de dados
CALL "VALIDATE-RECORD" USING DATA-RECORD, VALIDATION-RESULT
    RETURNING VALID-FLAG

* Finalização
CALL "CLOSE-DATA-READER" RETURNING CLOSE-STATUS
```

#### **Parâmetros de Configuração**
```cobol
01 WS-CONFIG.
   05 INPUT-FILE-NAME    PIC X(255).
   05 FILE-FORMAT        PIC X(10) VALUE "CSV".
   05 VALIDATION-LEVEL   PIC 9 VALUE 1.
   05 ERROR-HANDLING     PIC X VALUE "LOG".
```

#### **Códigos de Retorno**
```cobol
* Status codes
88 SUCCESS-STATUS       VALUE "00".
88 FILE-NOT-FOUND       VALUE "01".
88 INVALID-FORMAT        VALUE "02".
88 VALIDATION-ERROR      VALUE "03".
88 SYSTEM-ERROR         VALUE "99".
```

### **statistics.cbl - Motor Estatístico**

#### **Funções de Cálculo**
```cobol* Cálculo de média
CALL "CALCULATE-MEAN" USING DATA-ARRAY, ARRAY-SIZE, MEAN-RESULT
    RETURNING CALC-STATUS

* Cálculo de mediana
CALL "CALCULATE-MEDIAN" USING DATA-ARRAY, ARRAY-SIZE, MEDIAN-RESULT
    RETURNING CALC-STATUS

* Cálculo de moda
CALL "CALCULATE-MODE" USING DATA-ARRAY, ARRAY-SIZE, MODE-RESULT
    RETURNING CALC-STATUS

* Análise por departamento
CALL "DEPT-ANALYSIS" USING DATA-ARRAY, DEPT-RESULTS
    RETURNING ANALYSIS-STATUS
```

#### **Estruturas de Dados**
```cobol
01 STATISTICS-RESULTS.
   05 MEAN-VALUE         PIC 9(8)V99.
   05 MEDIAN-VALUE       PIC 9(8)V99.
   05 MODE-VALUE         PIC 9(8)V99.
   05 STD-DEVIATION      PIC 9(8)V99.
   05 SAMPLE-SIZE        PIC 9(8).

01 DEPT-STATISTICS.
   05 DEPT-CODE          PIC X(10).
   05 DEPT-COUNT         PIC 9(5).
   05 DEPT-MEAN          PIC 9(8)V99.
   05 DEPT-MIN           PIC 9(8)V99.
   05 DEPT-MAX           PIC 9(8)V99.
```

### **report_generator.cbl - Gerador de Relatórios**

#### **Templates de Relatório**
```cobol
* Relatório em texto
CALL "GENERATE-TEXT-REPORT" USING REPORT-DATA, TEMPLATE-ID, OUTPUT-FILE
    RETURNING REPORT-STATUS

* Relatório CSV
CALL "GENERATE-CSV-REPORT" USING REPORT-DATA, OUTPUT-FILE
    RETURNING REPORT-STATUS

* Relatório com cabeçalho
CALL "GENERATE-HEADER-REPORT" USING REPORT-DATA, HEADER-TEMPLATE, OUTPUT-FILE
    RETURNING REPORT-STATUS
```

#### **Configuração de Templates**
```cobol
01 REPORT-CONFIGURATION.
   05 TEMPLATE-ID         PIC X(20).
   05 OUTPUT-FORMAT       PIC X(10).
   05 INCLUDE-HEADER      PIC X VALUE "Y".
   05 INCLUDE-FOOTER      PIC X VALUE "Y".
   05 DATE-FORMAT         PIC X(20) VALUE "DD/MM/YYYY".
   05 DECIMAL-PLACES      PIC 9 VALUE 2.
```

## 🌐 **Integração Web (CGI)**

### **Interface CGI**
```cobol
IDENTIFICATION DIVISION.
PROGRAM-ID. WEB-INTERFACE.
AUTHOR. ENTERPRISE SYSTEMS.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CONSOLE IS CRT.

DATA DIVISION.
WORKING-STORAGE SECTION.
01 WS-CGI-VARIABLES.
   05 QUERY-STRING        PIC X(1024).
   05 REQUEST-METHOD      PIC X(10).
   05 CONTENT-TYPE        PIC X(50).
   05 CONTENT-LENGTH      PIC 9(5).

01 WS-RESPONSE.
   05 HTTP-HEADER         PIC X(200).
   05 JSON-OUTPUT        PIC X(10000).
```

### **Endpoint de API**
```cobol
* Processar requisição HTTP
PERFORM PROCESS-HTTP-REQUEST

* Gerar resposta JSON
PERFORM GENERATE-JSON-RESPONSE

* Enviar resposta
PERFORM SEND-HTTP-RESPONSE
```

### **Exemplo de Saída JSON**
```json
{
  "status": "success",
  "timestamp": "2024-03-08T12:00:00Z",
  "data": {
    "total_records": 1000,
    "statistics": {
      "mean_salary": 5500.00,
      "median_salary": 5200.00,
      "mode_salary": 5000.00
    },
    "departments": [
      {
        "code": "TI",
        "count": 45,
        "mean_salary": 6200.00
      }
    ]
  }
}
```

## 🔄 **Integração com Sistemas Externos**

### **Banco de Dados**
```cobol
* Conexão com banco via SQL
EXEC SQL
    CONNECT TO 'database' USER 'user' USING 'password'
END-EXEC

* Query de dados
EXEC SQL
    SELECT id, name, salary, department
    INTO :EMP-ID, :EMP-NAME, :EMP-SALARY, :EMP-DEPT
    FROM employees
    WHERE active = 1
END-EXEC

* Processamento com dados do BD
PERFORM PROCESS-DATABASE-RECORDS
```

### **Web Services**
```cobol
* Chamada a REST API
CALL "HTTP-GET" USING API-URL, HEADERS, RESPONSE
    RETURNING HTTP-STATUS

* Parse JSON response
CALL "PARSE-JSON" USING RESPONSE, DATA-STRUCTURE
    RETURNING PARSE-STATUS

* Processamento de dados externos
PERFORM PROCESS-EXTERNAL-DATA
```

### **File System Integration**
```cobol
* Monitorar diretório
CALL "WATCH-DIRECTORY" USING DIR-PATH, CALLBACK-FUNCTION
    RETURNING WATCH-STATUS

* Processar novos arquivos
PERFORM PROCESS-NEW-FILES

* Mover arquivos processados
CALL "MOVE-FILE" USING SOURCE-PATH, DEST-PATH
    RETURNING MOVE-STATUS
```

## 📊 **Formatos de Dados Suportados**

### **CSV (Comma-Separated Values)**
```csv
ID,NOME,IDADE,SALARIO,DEPARTAMENTO
001,JOAO SILVA,35,5000.00,TI
002,ANA SOUZA,28,4500.00,RH
```

### **Fixed-Width Format**
```
001JOAO SILVA          3505000.00TI            
002ANA SOUZA           2804500.00RH            
```

### **JSON (JavaScript Object Notation)**
```json
[
  {
    "id": "001",
    "name": "JOAO SILVA",
    "age": 35,
    "salary": 5000.00,
    "department": "TI"
  }
]
```

### **XML (eXtensible Markup Language)**
```xml
<?xml version="1.0"?>
<employees>
  <employee>
    <id>001</id>
    <name>JOAO SILVA</name>
    <age>35</age>
    <salary>5000.00</salary>
    <department>TI</department>
  </employee>
</employees>
```

## 🔍 **Validação e Error Handling**

### **Códigos de Erro**
```cobol
01 ERROR-CODES.
   88 SUCCESS              VALUE 0.
   88 FILE-ERROR           VALUE 100.
   88 VALIDATION-ERROR     VALUE 200.
   88 CALCULATION-ERROR    VALUE 300.
   88 SYSTEM-ERROR         VALUE 400.
   88 NETWORK-ERROR        VALUE 500.
```

### **Logging**
```cobol
* Registrar erro
CALL "LOG-ERROR" USING ERROR-CODE, ERROR-MESSAGE, TIMESTAMP
    RETURNING LOG-STATUS

* Registrar informação
CALL "LOG-INFO" USING INFO-MESSAGE, TIMESTAMP
    RETURNING LOG-STATUS

* Registrar debug
CALL "LOG-DEBUG" USING DEBUG-MESSAGE, TIMESTAMP
    RETURNING LOG-STATUS
```

### **Recuperação de Erros**
```cobol
* Tentar recuperação automática
PERFORM ERROR-RECOVERY

* Notificar administrador
CALL "SEND-ALERT" USING ALERT-TYPE, ALERT-MESSAGE
    RETURNING ALERT-STATUS

* Continuar processamento
PERFORM CONTINUE-PROCESSING
```

## ⚡ **Performance & Otimização**

### **Batch Processing**
```cobol
* Processar em lotes
PERFORM PROCESS-BATCH
    VARYING BATCH-COUNTER FROM 1 BY 1
    UNTIL BATCH-COUNTER > TOTAL-BATCHES
```

### **Parallel Processing**
```cobol
* Iniciar threads paralelas
CALL "START-PARALLEL-TASKS" USING TASK-LIST
    RETURNING PARALLEL-STATUS

* Aguardar conclusão
CALL "WAIT-TASKS-COMPLETE" RETURNING COMPLETION-STATUS
```

### **Memory Management**
```cobol
* Alocar memória dinamicamente
CALL "ALLOCATE-MEMORY" USING MEMORY-SIZE, MEMORY-PTR
    RETURNING ALLOC-STATUS

* Liberar memória
CALL "FREE-MEMORY" USING MEMORY-PTR
    RETURNING FREE-STATUS
```

## 🧪 **Testes Unitários**

### **Framework de Testes**
```cobol
* Setup de teste
PERFORM TEST-SETUP

* Executar teste
CALL "ASSERT-EQUALS" USING EXPECTED, ACTUAL, TEST-NAME
    RETURNING TEST-RESULT

* Cleanup de teste
PERFORM TEST-CLEANUP
```

### **Testes de Integração**
```cobol
* Testar integração completa
PERFORM INTEGRATION-TEST

* Validar resultados
PERFORM VALIDATE-RESULTS

* Gerar relatório de teste
PERFORM GENERATE-TEST-REPORT
```

## 📚 **Exemplos de Uso**

### **Exemplo 1: Processamento Batch**
```bash
#!/bin/bash
# Script de processamento batch

for file in data/*.dat; do
    echo "Processando $file..."
    ./bin/data-analysis --input="$file" --output="reports/$(basename $file).rpt"
    
    if [ $? -eq 0 ]; then
        echo "✅ $file processado com sucesso"
    else
        echo "❌ Erro ao processar $file"
    fi
done
```

### **Exemplo 2: Integração Python**
```python
import subprocess
import json

def process_cobol_analysis(input_file):
    """Executa análise COBOL e retorna resultados"""
    cmd = ['./bin/data-analysis', '--input', input_file, '--format', 'json']
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode == 0:
        return json.loads(result.stdout)
    else:
        raise Exception(f"Erro: {result.stderr}")

# Uso
results = process_cobol_analysis('data/input.dat')
print(f"Total de registros: {results['total_records']}")
```

### **Exemplo 3: Monitoramento em Tempo Real**
```cobol
* Loop de monitoramento
PERFORM UNTIL SHUTDOWN-FLAG = "Y"
    CALL "CHECK-NEW-FILES" USING DATA-DIR, NEW-FILES
    IF NEW-FILES > 0
        PERFORM PROCESS-NEW-FILES
    END-IF
    
    CALL "SLEEP" USING 5000  * 5 segundos
END-PERFORM
```

---

**🔗 Esta API permite integração completa do sistema COBOL com aplicações modernas, mantendo a robustez e performance do COBOL Enterprise.**

## 📞 **Suporte Técnico**

- **Documentação**: [docs/DOCUMENTACAO.md](DOCUMENTACAO.md)
- **Instalação**: [docs/INSTALL.md](INSTALL.md)
- **Issues**: GitHub Issues
- **Email**: seu-email@dominio.com
