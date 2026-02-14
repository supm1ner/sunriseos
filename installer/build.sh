#!/bin/bash

# Скрипт для сборки установщика

set -e

echo "Сборка SunriseOS Installer..."

cd "$(dirname "$0")"

# Сборка в release режиме
cargo build --release

# Копирование бинарника
cp target/release/sunriseos-installer ../airootfs/usr/local/bin/

echo "Готово! Бинарник скопирован в airootfs/usr/local/bin/"
