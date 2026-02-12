#!/bin/bash

# Скрипт для запуска на Linux машине
# Использование: bash remote_build.sh

set -e

echo "=== Обновление репозитория ==="
cd ~/sunriseos || cd /home/supminer/sunriseos || { echo "Директория sunriseos не найдена"; exit 1; }

git fetch origin
git reset --hard origin/main

echo ""
echo "=== Проверка файлов ==="
echo "bootmodes:"
grep bootmodes profiledef.sh

echo ""
echo "packages (первые 10 строк):"
head -10 packages.x86_64

echo ""
echo "=== Запуск сборки ==="
sudo ./build.sh

echo ""
echo "=== Готово! ==="
ls -lh out/
