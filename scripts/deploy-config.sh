#!/bin/bash

# Script de deployment automatizado
# Autor: [Tu nombre]

set -e

CONFIG_FILE="${1:-configs/nginx/load-balancer}"
BACKUP_DIR="/etc/nginx/backup"

echo "========================================="
echo "DEPLOYMENT DE CONFIGURACIÓN NGINX"
echo "========================================="

# Crear directorio de backup
sudo mkdir -p $BACKUP_DIR/$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"

# Backup de configuración actual
echo "1. Creando backup..."
sudo cp -r /etc/nginx/sites-available/* $BACKUP_PATH/
echo "   Backup creado en: $BACKUP_PATH"

# Copiar nueva configuración
echo "2. Copiando nueva configuración..."
sudo cp $CONFIG_FILE /etc/nginx/sites-available/load-balancer

# Validar sintaxis
echo "3. Validando sintaxis..."
if sudo nginx -t 2>&1; then
    echo "   ✓ Sintaxis correcta"
else
    echo "   ✗ Error en sintaxis. Restaurando backup..."
    sudo cp $BACKUP_PATH/* /etc/nginx/sites-available/
    exit 1
fi

# Recargar Nginx
echo "4. Recargando Nginx..."
sudo systemctl reload nginx

if [ $? -eq 0 ]; then
    echo "   ✓ Nginx recargado exitosamente"
    echo ""
    echo "========================================="
    echo "✓ DEPLOYMENT COMPLETADO"
    echo "========================================="
else
    echo "   ✗ Error al recargar. Restaurando backup..."
    sudo cp $BACKUP_PATH/* /etc/nginx/sites-available/
    sudo systemctl reload nginx
    exit 1
fi
