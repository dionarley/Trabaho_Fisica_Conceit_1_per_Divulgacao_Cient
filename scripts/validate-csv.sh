#!/bin/bash
# Validate CSV files structure
# Usage: ./scripts/validate-csv.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Validating CSV Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CSV_DIR="planilhas"
ERRORS=0

# Define expected headers for each CSV (using actual delimiters)
declare -A EXPECTED_HEADERS
EXPECTED_HEADERS["membros-grupo.csv"]="Nome Completo;RAM;E-mail Institucional;WhatsApp;Semestre;Dias Disponiveis;Melhor Horario;Disponibilidade Semanal;Preferencias;Experiencia;Recursos;Confirma Participacao;Observacoes"
EXPECTED_HEADERS["materiais-papel.csv"]="ITEM,TIPO,GRAMATURA,TAMANHO,USO,PRECO_MEDIO_UNITARIO,PRECO_MEDIO_RECMA,ONDE_COMPRAR"
EXPECTED_HEADERS["impressoras-comparacao.csv"]="MODELO,TIPO,PRECO_INICIAL,RENDIMENTO,CUSTO_POR_PAGINA,MELHOR_PARA"
EXPECTED_HEADERS["orcamento-projeto.csv"]="SERVICO,FORMATO,PAPEL,QUANTIDADE,PRECO_UNITARIO,TOTAL,PRAZO,ONDE"

for csv_file in "$CSV_DIR"/*.csv; do
    if [ ! -f "$csv_file" ]; then
        continue
    fi
    
    filename=$(basename "$csv_file")
    echo "Checking: $filename"
    
    # Check if file is readable
    if ! head -1 "$csv_file" > /dev/null 2>&1; then
        echo "  ✗ Cannot read file"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    
    # Get header
    HEADER=$(head -1 "$csv_file")
    
    # Check if expected header exists
    if [ -z "${EXPECTED_HEADERS[$filename]}" ]; then
        echo "  ⚠ No validation rules for this file"
        echo "  Header: $HEADER"
        continue
    fi
    
    EXPECTED="${EXPECTED_HEADERS[$filename]}"
    
    if [ "$HEADER" = "$EXPECTED" ]; then
        echo "  ✓ Header correct"
    else
        echo "  ✗ Header mismatch!"
        echo "    Expected: $EXPECTED"
        echo "    Found:    $HEADER"
        ERRORS=$((ERRORS + 1))
    fi
    
    # Count data rows
    ROWS=$(tail -n +2 "$csv_file" | grep -c "^" || echo "0")
    echo "  Data rows: $ROWS"
    
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo "  ✓ All CSV files are valid!"
else
    echo "  ✗ Found $ERRORS error(s)"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
