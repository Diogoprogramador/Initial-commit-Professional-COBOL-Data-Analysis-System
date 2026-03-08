# Makefile for COBOL Data Analysis Project

CC = cobc
CFLAGS = -free -x -Wall
SRCDIR = src
DATADIR = data
BINDIR = bin
DOCDIR = docs

# Source files
MAIN_SRC = $(SRCDIR)/fixed_format.cbl
DATA_READER_SRC = $(SRCDIR)/data_reader.cbl
STATISTICS_SRC = $(SRCDIR)/statistics.cbl
REPORT_SRC = $(SRCDIR)/report_generator.cbl

# Output executable
TARGET = $(BINDIR)/data-analysis

# Create directories
$(BINDIR):
	mkdir -p $(BINDIR)

$(DATADIR):
	mkdir -p $(DATADIR)

$(DOCDIR):
	mkdir -p $(DOCDIR)

# Compile main program
all: $(BINDIR) $(TARGET)

$(TARGET): $(MAIN_SRC)
	$(CC) $(CFLAGS) -o $@ $<

# Compile demo program
demo: $(BINDIR)
	$(CC) $(CFLAGS) -o $(BINDIR)/demo $(SRCDIR)/fixed_format.cbl

# Compile portfolio demo
portfolio: $(BINDIR)
	$(CC) $(CFLAGS) -o $(BINDIR)/portfolio_demo examples/portfolio_demo.cbl

# Compile individual modules for testing
data_reader: $(BINDIR) $(DATA_READER_SRC)
	$(CC) $(CFLAGS) -o $(BINDIR)/data_reader $<

statistics: $(BINDIR) $(STATISTICS_SRC)
	$(CC) $(CFLAGS) -o $(BINDIR)/statistics $<

report_generator: $(BINDIR) $(REPORT_SRC)
	$(CC) $(CFLAGS) -o $(BINDIR)/report_generator $<

# Create sample data
sample-data: $(DATADIR)
	@echo "Creating sample data files..."
	@echo "ID,NOME,IDADE,SALARIO,DEPARTAMENTO" > $(DATADIR)/sample.dat
	@echo "001,JOAO SILVA,35,5000.00,TI" >> $(DATADIR)/sample.dat
	@echo "002,ANA SOUZA,28,4500.00,RH" >> $(DATADIR)/sample.dat
	@echo "003,CARLOS SANTOS,42,6500.00,FINANCEIRO" >> $(DATADIR)/sample.dat
	@echo "004,MARIA OLIVEIRA,31,5200.00,TI" >> $(DATADIR)/sample.dat
	@echo "005,PEDRO COSTA,38,5800.00,MARKETING" >> $(DATADIR)/sample.dat
	@echo "006,LUCIA FERREIRA,26,4200.00,RH" >> $(DATADIR)/sample.dat
	@echo "007,ROBERTO LIMA,45,7200.00,FINANCEIRO" >> $(DATADIR)/sample.dat
	@echo "008,JOANA BARROS,33,5500.00,TI" >> $(DATADIR)/sample.dat

# Run the program
run: $(TARGET)
	./$(TARGET)

# Run demo
run-demo: demo
	./$(BINDIR)/demo

# Run portfolio demo
run-portfolio: portfolio
	./$(BINDIR)/portfolio_demo

# Test with sample data
test: demo sample-data run-demo

# Clean build artifacts
clean:
	rm -rf $(BINDIR)/*
	rm -f *.lis *.lst *.c *.h

# Install dependencies (placeholder for future use)
install-deps:
	@echo "Installing dependencies..."
	@echo "Please install GnuCOBOL: sudo apt-get install gnucobol4"

# Generate documentation
docs: $(DOCDIR)
	@echo "Generating documentation..."
	@echo "Documentation generated in $(DOCDIR)/"

# Show project info
info:
	@echo "=== COBOL Data Analysis Project ==="
	@echo "Compiler: $(CC)"
	@echo "Flags: $(CFLAGS)"
	@echo "Source dir: $(SRCDIR)"
	@echo "Binary dir: $(BINDIR)"
	@echo "Data dir: $(DATADIR)"

.PHONY: all clean run test sample-data install-deps docs info demo run-demo run-portfolio portfolio data_reader statistics report_generator
