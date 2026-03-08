# Documentação do Projeto de Análise de Dados em COBOL

## Visão Geral

Este projeto demonstra o uso de COBOL moderno para análise de dados estruturados, incluindo processamento de arquivos, cálculos estatísticos e geração de relatórios.

## Arquitetura

### Módulos Principais

#### 1. main.cbl - Programa Principal
- **Função**: Orquestrador principal do sistema
- **Responsabilidades**:
  - Inicialização do sistema
  - Coordenação dos módulos
  - Geração de relatório consolidado

#### 2. data_reader.cbl - Leitor de Dados
- **Função**: Leitura e validação de arquivos de dados
- **Responsabilidades**:
  - Leitura de arquivos CSV
  - Validação de campos (idade, salário, departamento)
  - Contabilização de erros
  - Geração de estatísticas de leitura

#### 3. statistics.cbl - Módulo Estatístico
- **Função**: Cálculos estatísticos avançados
- **Responsabilidades**:
  - Cálculo de médias (idade, salário)
  - Cálculo de mediana
  - Cálculo de moda
  - Análise por departamento
  - Ordenação de dados

#### 4. report_generator.cbl - Gerador de Relatórios
- **Função**: Criação de relatórios formatados
- **Responsabilidades**:
  - Geração de relatórios em texto
  - Exportação para CSV
  - Formatação de dados
  - Cálculo de totais e estatísticas

## Formato de Dados

### Arquivo de Entrada (CSV)
```
ID,NOME,IDADE,SALARIO,DEPARTAMENTO
001,JOAO SILVA,35,5000.00,TI
002,ANA SOUZA,28,4500.00,RH
...
```

### Campos
- **ID**: Código do funcionário (3 caracteres)
- **NOME**: Nome completo (20 caracteres)
- **IDADE**: Idade em anos (18-70)
- **SALARIO**: Salário mensal (1000.00-50000.00)
- **DEPARTAMENTO**: Departamento (15 caracteres)

## Validações Implementadas

### Validação de Idade
- Mínimo: 18 anos
- Máximo: 70 anos
- Erro: "IDADE INVALIDA"

### Validação de Salário
- Mínimo: R$ 1.000,00
- Máximo: R$ 50.000,00
- Erro: "SALARIO INVALIDO"

### Validação de Departamento
- Não pode ser vazio
- Erro: "DEPARTAMENTO INVALIDO"

## Estatísticas Calculadas

### Estatísticas Gerais
- Total de registros
- Média de idade
- Média salarial
- Maior e menor salário

### Estatísticas por Departamento
- Contagem de funcionários
- Média salarial por departamento
- Distribuição percentual

### Estatísticas Avançadas
- Mediana salarial
- Moda salarial
- Desvio padrão (futuro)

## Relatórios Gerados

### Relatório em Texto
- Cabeçalho com data/hora
- Tabela formatada de dados
- Resumo estatístico
- Totais e médias

### Relatório CSV
- Formato compatível com Excel
- Mesmos dados do relatório texto
- Facilidade para análise externa

## Compilação

### Pré-requisitos
```bash
# Ubuntu/Debian
sudo apt-get install open-cobol

# CentOS/RHEL
sudo yum install open-cobol

# Fedora
sudo dnf install open-cobol
```

### Comandos de Compilação
```bash
# Compilar programa principal
cobc -x -std=cobol2014 src/main.cbl -o bin/main

# Compilar módulos individuais
cobc -x -std=cobol2014 src/data_reader.cbl -o bin/data_reader
cobc -x -std=cobol2014 src/statistics.cbl -o bin/statistics
cobc -x -std=cobol2014 src/report_generator.cbl -o bin/report_generator
```

## Uso

### Execução Completa
```bash
make all
make run
```

### Execução Individual
```bash
# Testar leitor de dados
./bin/data_reader

# Testar estatísticas
./bin/statistics

# Testar gerador de relatórios
./bin/report_generator
```

## Extensões Futuras

### Planejado
- [ ] Interface web (CGI)
- [ ] Integração com banco de dados
- [ ] Gráficos e visualizações
- [ ] Processamento em tempo real
- [ ] API REST

### Melhorias
- [ ] Tratamento de erros avançado
- [ ] Logging detalhado
- [ ] Configuração externa
- [ ] Testes automatizados
- [ ] Performance tuning

## Boas Práticas

### Código COBOL
- Usar COBOL 2014 quando possível
- Nomenclatura clara e consistente
- Comentários em português
- Indentação padrão

### Performance
- Evitar loops desnecessários
- Usar tabelas eficientemente
- Minimizar I/O
- Otimizar memória

### Manutenibilidade
- Modularização clara
- Documentação completa
- Testes unitários
- Versionamento semântico

## Troubleshooting

### Erros Comuns

#### "Arquivo não encontrado"
- Verifique caminho no FILE-CONTROL
- Confirme permissões de leitura
- Use caminhos relativos

#### "Status de arquivo inválido"
- Verifique organização do arquivo
- Confirme formato dos dados
- Valide estrutura do registro

#### "Erro de compilação"
- Verifique sintaxe COBOL
- Confirme versão do compilador
- Verifique dependências

## Referências

- [GnuCOBOL Documentation](https://gnucobol.sourceforge.io/)
- [COBOL 2014 Standard](https://www.iso.org/standard/63549.html)
- [Modern COBOL Best Practices](https://moderncobol.com/)
