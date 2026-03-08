#!/bin/bash

# Script de setup para o projeto COBOL Data Analysis

echo "=== Setup do Projeto COBOL Data Analysis ==="

# Verificar se GnuCOBOL está instalado
if ! command -v cobc &> /dev/null; then
    echo "AVISO: GnuCOBOL não encontrado. Instale com:"
    echo "sudo apt-get install gnucobol4"
    exit 1
fi

# Criar estrutura de diretórios
echo "Criando estrutura de diretórios..."
mkdir -p bin data docs examples

# Compilar projeto
echo "Compilando projeto..."
make demo

# Testar execução
echo "Testando execução..."
if [ -f "bin/demo" ]; then
    echo "✓ Compilação bem sucedida!"
    echo "Executando demo:"
    ./bin/demo
else
    echo "✗ Erro na compilação"
    exit 1
fi

# Inicializar Git se não existir
if [ ! -d ".git" ]; then
    echo "Inicializando repositório Git..."
    git init
    git add .
    git commit -m "Initial commit: COBOL Data Analysis Project"
    echo "✓ Repositório Git inicializado"
else
    echo "Repositório Git já existe"
fi

echo ""
echo "=== Setup concluído! ==="
echo "Para subir para GitHub:"
echo "1. Crie um repositório no GitHub"
echo "2. Execute: git remote add origin <URL-DO-REPOSITORIO>"
echo "3. Execute: git push -u origin main"
echo ""
echo "Comandos úteis:"
echo "make demo     - Compila o programa demo"
echo "make run-demo - Executa o demo"
echo "make clean    - Limpa binários"
echo "make info     - Mostra informações do projeto"
