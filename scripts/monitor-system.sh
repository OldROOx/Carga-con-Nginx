#!/bin/bash

# Script de monitoreo completo del sistema de balanceo
# Autor: [Tu nombre]
# Uso: ./monitor-system.sh

LOG_FILE="/var/log/loadbalancer-monitor.log"
BACKENDS=("IP_BACKEND_1:8080" "IP_BACKEND_2:8081" "IP_BACKEND_3:8082")
ALERT_THRESHOLD=3

echo "========================================" | tee -a $LOG_FILE
echo "Monitor ejecutado: $(date)" | tee -a $LOG_FILE
echo "========================================" | tee -a $LOG_FILE

# Función para verificar backend
check_backend() {
    local backend=$1
    local name=$2
    
    if timeout 5 curl -sf http://${backend}/health > /dev/null 2>&1; then
        echo "[✓] ${name} (${backend}) está ACTIVO" | tee -a $LOG_FILE
        return 0
    else
        echo "[✗] ${name} (${backend}) está CAÍDO" | tee -a $LOG_FILE
        return 1
    fi
}

# Verificar cada backend
failed=0
for i in "${!BACKENDS[@]}"; do
    check_backend "${BACKENDS[$i]}" "Backend-$((i+1))" || ((failed++))
done

# Verificar Nginx
if systemctl is-active --quiet nginx; then
    echo "[✓] Nginx está ACTIVO" | tee -a $LOG_FILE
else
    echo "[✗] Nginx está CAÍDO - Intentando reiniciar..." | tee -a $LOG_FILE
    systemctl restart nginx
    failed=$((failed+1))
fi

# Estadísticas de conexiones
echo "" | tee -a $LOG_FILE
echo "=== Estadísticas de Conexiones ===" | tee -a $LOG_FILE
for port in 8080 8081 8082; do
    count=$(ss -tn | grep ":$port" | wc -l)
    echo "Puerto $port: $count conexiones activas" | tee -a $LOG_FILE
done

# Uso de recursos
echo "" | tee -a $LOG_FILE
echo "=== Uso de Recursos ===" | tee -a $LOG_FILE
echo "CPU Load: $(uptime | awk -F'load average:' '{print $2}')" | tee -a $LOG_FILE
echo "Memoria: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')" | tee -a $LOG_FILE
echo "Disco: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')" | tee -a $LOG_FILE

# Alertas
if [ $failed -ge $ALERT_THRESHOLD ]; then
    echo "" | tee -a $LOG_FILE
    echo "⚠️  ALERTA: $failed servicios caídos" | tee -a $LOG_FILE
    # Aquí podrías enviar email o notificación
fi

echo "========================================" | tee -a $LOG_FILE
echo ""
