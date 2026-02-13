#!/bin/bash
# Скрипт автозапуска для live системы

# Ждем немного
sleep 2

# Запускаем GNOME если не запущен
if [ -z "$DISPLAY" ]; then
    exec startx
fi
