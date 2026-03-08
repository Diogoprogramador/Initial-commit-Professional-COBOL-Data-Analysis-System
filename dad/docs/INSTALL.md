# 📦 Guia de Instalação - COBOL Data Analysis System

## 🎯 **Visão Geral**

Guia completo para instalação e configuração do sistema de análise de dados COBOL em ambientes empresariais.

## 📋 **Requisitos de Sistema**

### **Hardware Mínimo**
- **CPU**: 1.0 GHz (recomendado: 2.0+ GHz)
- **RAM**: 512 MB (recomendado: 2+ GB)
- **Disco**: 100 MB livre
- **SO**: Linux, Unix, Windows (com WSL)

### **Software Necessário**
- **GnuCOBOL** 2.0+ (recomendado: 4.0)
- **Make** 3.8+
- **Git** 2.0+
- **Terminal/Shell**

## 🔧 **Instalação por Sistema Operacional**

### **🐧 Ubuntu/Debian**
```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar GnuCOBOL e dependências
sudo apt install -y gnucobol4 make git

# Verificar instalação
cobc --version
```

### **🔴 CentOS/RHEL/Fedora**
```bash
# CentOS/RHEL
sudo yum install -y gnucobol make git

# Fedora
sudo dnf install -y gnucobol make git

# Verificar instalação
cobc --version
```

### **🪟 Windows (WSL)**
```bash
# Instalar WSL2 primeiro
wsl --install -d Ubuntu

# No WSL Ubuntu
sudo apt update
sudo apt install -y gnucobol4 make git
```

### **🍎 macOS**
```bash
# Instalar Homebrew (se não tiver)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar GnuCOBOL
brew install gnucobol

# Verificar instalação
cobc --version
```

## 🚀 **Setup do Projeto**

### **1. Clonar Repositório**
```bash
git clone https://github.com/SEU-USUARIO/cobol-data-analysis.git
cd cobol-data-analysis
```

### **2. Setup Automático**
```bash
# Executar script de configuração
chmod +x setup.sh
./setup.sh
```

### **3. Verificação Manual**
```bash
# Compilar projeto
make demo

# Executar demo
make run-demo

# Verificar informações
make info
```

## ⚙️ **Configuração Avançada**

### **Variáveis de Ambiente**
```bash
# Adicionar ao ~/.bashrc ou ~/.zshrc
export COBOL_PROJECT_PATH="$HOME/cobol-data-analysis"
export COBOL_DATA_DIR="$COBOL_PROJECT_PATH/data"
export COBOL_BIN_DIR="$COBOL_PROJECT_PATH/bin"

# Recarregar ambiente
source ~/.bashrc
```

### **Configuração do Compilador**
```bash
# Verificar flags disponíveis
cobc --help

# Configurar flags padrão no Makefile
# CFLAGS = -free -x -Wall -O2
```

### **Permissões de Arquivos**
```bash
# Garantir permissões de execução
chmod +x setup.sh
chmod +x bin/*
chmod -R 755 src/
chmod -R 644 data/
```

## 🏗️ **Build System**

### **Comandos Make Disponíveis**
```bash
# Build completo
make all

# Demo apenas
make demo

# Execução
make run-demo

# Limpeza
make clean

# Informações
make info

# Ajuda
make help
```

### **Build de Produção**
```bash
# Compilação otimizada
make CFLAGS="-free -x -Wall -O2" all

# Verificar binário
file bin/demo
ls -la bin/
```

## 🧪 **Testes e Validação**

### **Teste Básico**
```bash
# Executar demo
./bin/demo

# Verificar saída esperada
echo "✅ Demo executou com sucesso"
```

### **Teste de Dados**
```bash
# Criar dados de teste
make sample-data

# Verificar arquivos
ls -la data/
head data/sample.dat
```

### **Teste de Performance**
```bash
# Medir tempo de execução
time make run-demo

# Verificar uso de memória
/usr/bin/time -v make run-demo
```

## 🔍 **Troubleshooting**

### **Problemas Comuns**

#### **❌ "cobc: command not found"**
```bash
# Verificar instalação
which cobc

# Reinstalar se necessário
sudo apt install --reinstall gnucobol4

# Adicionar ao PATH
export PATH=$PATH:/usr/bin
```

#### **❌ Erros de permissão**
```bash
# Corrigir permissões
sudo chown -R $USER:$USER .
chmod +x setup.sh
chmod -R 755 src/
```

#### **❌ Erros de compilação**
```bash
# Verificar sintaxe COBOL
cobc -fsyntax-only src/fixed_format.cbl

# Compilar com debug
cobc -free -x -g -DDEBUG src/fixed_format.cbl -o bin/debug
```

#### **❌ Problemas com arquivos de dados**
```bash
# Verificar formato dos dados
file data/input.dat
head data/input.dat

# Validar CSV
python3 -c "import csv; csv.Sniffer().sniff(open('data/input.dat').read())"
```

### **Logs e Debug**

### **Habilitar Debug**
```bash
# Compilar com símbolos de debug
cobc -free -x -g src/fixed_format.cbl -o bin/debug

# Executar com debugger
gdb ./bin/debug
```

### **Verbose Output**
```bash
# Compilação detalhada
cobc -v -free -x src/fixed_format.cbl -o bin/demo

# Execução com tracing
./bin/demo 2>&1 | tee execution.log
```

## 🚀 **Deploy em Produção**

### **Ambiente de Produção**
```bash
# Criar usuário dedicado
sudo useradd -m coboluser
sudo su - coboluser

# Instalar dependências
sudo apt install gnucobol4 make git

# Clonar projeto
git clone https://github.com/SEU-USUARIO/cobol-data-analysis.git
cd cobol-data-analysis

# Configurar
./setup.sh
```

### **Configuração de Serviço**
```bash
# Criar systemd service (opcional)
sudo tee /etc/systemd/system/cobol-analysis.service << EOF
[Unit]
Description=COBOL Data Analysis Service
After=network.target

[Service]
Type=simple
User=coboluser
WorkingDirectory=/home/coboluser/cobol-data-analysis
ExecStart=/home/coboluser/cobol-data-analysis/bin/data-analysis
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Habilitar serviço
sudo systemctl enable cobol-analysis
sudo systemctl start cobol-analysis
```

### **Monitoramento**
```bash
# Verificar status
sudo systemctl status cobol-analysis

# Verificar logs
sudo journalctl -u cobol-analysis -f

# Monitorar recursos
htop
iostat -x 1
```

## 📊 **Performance & Otimização**

### **Otimizações de Compilação**
```bash
# Compilação otimizada
make CFLAGS="-free -x -Wall -O3 -march=native" all

# Verificar ganhos de performance
time make run-demo
```

### **Otimizações de Runtime**
```bash
# Configurar limites de recursos
ulimit -s unlimited
ulimit -d unlimited

# Ajustar prioridade
nice -n 10 ./bin/demo
```

## 🔄 **Manutenção**

### **Backup**
```bash
# Backup completo
tar -czf cobol-analysis-backup-$(date +%Y%m%d).tar.gz .

# Backup apenas dados
tar -czf cobol-data-backup-$(date +%Y%m%d).tar.gz data/
```

### **Atualização**
```bash
# Atualizar código
git pull origin main

# Recompilar
make clean
make all

# Testar
make run-demo
```

### **Limpeza**
```bash
# Limpar artefatos
make clean

# Limpar logs
find . -name "*.log" -delete

# Limpar temporários
find . -name "*.tmp" -delete
find . -name "*.bak" -delete
```

## 📞 **Suporte**

### **Recursos**
- **Documentação**: [docs/DOCUMENTACAO.md](DOCUMENTACAO.md)
- **Issues**: GitHub Issues
- **Wiki**: GitHub Wiki

### **Contato**
- 📧 Email: seu-email@dominio.com
- 💼 LinkedIn: linkedin.com/in/seu-perfil
- 🐙 GitHub: github.com/seu-usuario

---

**🎉 Instalação concluída!** O sistema está pronto para uso empresarial.

### **Próximos Passos**
1. Execute `make run-demo` para testar
2. Explore a documentação em `docs/`
3. Verifique os exemplos em `examples/`
4. Configure seus dados em `data/`
