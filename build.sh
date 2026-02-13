#!/bin/bash

set -e

# Проверка прав root
if [ "$EUID" -ne 0 ]; then 
    echo "Запустите скрипт с правами root (sudo)"
    exit 1
fi

# Сборка установщика
echo "Сборка установщика SunriseOS..."
if [ -d "installer" ]; then
    cd installer
    if command -v cargo &> /dev/null; then
        cargo build --release 2>/dev/null || echo "Не удалось собрать установщик, пропускаем..."
        if [ -f "target/release/sunriseos-installer" ]; then
            cp target/release/sunriseos-installer ../airootfs/usr/local/bin/
            echo "Установщик собран и скопирован"
        fi
    else
        echo "Cargo не найден, установщик не будет собран"
        echo "Установите rust: sudo pacman -S rust"
    fi
    cd ..
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
