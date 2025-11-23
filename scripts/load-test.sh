#!/bin/bash

# Script de pruebas de carga automatizado
# Autor: [Tu nombre]

TARGET_URL="${1:-http://localhost}"
REQUESTS="${2:-5000}"
CONCURRENCY="${3:-100}"
RESULTS_DIR="evidencias/load-tests"

mkdir -p $RESULTS_DIR

echo "========================================="
echo "PRUEBA DE CARGA"
echo "========================================="
echo "URL: $TARGET_URL"
echo "Requests: $REQUESTS"
echo "Concurrency: $CONCURRENCY"
echo "========================================="
echo ""

# Instalar ab si no existe
if ! command -v ab &> /dev/null; then
    echo "Instalando ApacheBench..."
    sudo apt install -y apache2-utils
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="$RESULTS_DIR/loadtest_${TIMESTAMP}.txt"

echo "Iniciando prueba de carga..." | tee $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Ejecutar ApacheBench
ab -n $REQUESTS -c $CONCURRENCY -g "$RESULTS_DIR/gnuplot_${TIMESTAMP}.tsv" $TARGET_URL/ 2>&1 | tee -a $OUTPUT_FILE

echo "" | tee -a $OUTPUT_FILE
echo "=========================================" | tee -a $OUTPUT_FILE
echo "Resultados guardados en: $OUTPUT_FILE"
echo "========================================="

# Análisis básico
echo "" | tee -a $OUTPUT_FILE
echo "=== RESUMEN ===" | tee -a $OUTPUT_FILE
grep "Requests per second" $OUTPUT_FILE
grep "Time per request" $OUTPUT_FILE
grep "Failed requests" $OUTPUT_FILE
