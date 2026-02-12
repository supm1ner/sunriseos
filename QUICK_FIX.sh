#!/bin/bash

# Быстрое исправление для Linux машины
# Запусти: bash QUICK_FIX.sh

echo "Обновляем файлы из репозитория..."
git fetch origin
git reset --hard origin/main

echo ""
echo "Проверяем изменения:"
echo "=== packages.x86_64 (должен быть syslinux) ==="
grep -A 2 "Base system" packages.x86_64

echo ""
echo "=== profiledef.sh (должен быть bios.syslinux без .mbr) ==="
grep bootmodes profiledef.sh

echo ""
echo "Если видишь правильные значения, запускай:"
echo "sudo ./build.sh"
