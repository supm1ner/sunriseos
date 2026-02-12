#!/bin/bash

set -e

# Проверка прав root
if [ "$EUID" -ne 0 ]; then 
    echo "Запустите скрипт с правами root (sudo)"
    exit 1
fi

# Очистка предыдущей сборки
echo "Очистка предыдущей сборки..."
rm -rf work/ out/

# Сборка ISO
echo "Начинаем сборку SunriseOS..."
mkarchiso -v -w work/ -o out/ .

echo ""
echo "=========================================="
echo "Сборка завершена!"
echo "ISO файл находится в директории: out/"
echo "=========================================="
