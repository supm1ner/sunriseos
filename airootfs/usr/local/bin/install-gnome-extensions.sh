#!/bin/bash

# Скрипт для установки GNOME расширений
# Запускается автоматически при первом входе

EXTENSIONS=(
    "3193"  # Blur my Shell
    "1160"  # Dash to Dock
    "307"   # Dash to Panel (alternative)
    "1319"  # GSConnect
    "19"    # User Themes
    "1460"  # Vitals
    "906"   # Sound Input & Output Device Chooser
    "1401"  # Bluetooth Quick Connect
)

echo "Установка GNOME расширений..."

for ext_id in "${EXTENSIONS[@]}"; do
    echo "Установка расширения ID: $ext_id"
    gdbus call --session \
        --dest org.gnome.Shell.Extensions \
        --object-path /org/gnome/Shell/Extensions \
        --method org.gnome.Shell.Extensions.InstallRemoteExtension \
        "$ext_id" 2>/dev/null || echo "Не удалось установить $ext_id"
done

echo "Готово! Перезайдите в систему для применения изменений."
