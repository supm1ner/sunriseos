# SunriseOS

Кастомный Linux дистрибутив на базе Arch Linux с GNOME и графическим установщиком Calamares.

## Требования для сборки

- Arch Linux или Arch-based дистрибутив
- archiso пакет
- Минимум 10GB свободного места
- Права root

## Установка зависимостей

```bash
sudo pacman -S archiso git
```

## Сборка ISO

```bash
sudo ./build.sh
```

Готовый ISO будет в директории `out/`

## Структура проекта

- `airootfs/` - файловая система live-окружения
- `profiledef.sh` - конфигурация профиля
- `packages.x86_64` - список пакетов для установки
- `build.sh` - скрипт сборки
- `syslinux/` - конфигурация загрузчика

## Особенности

- GNOME Desktop Environment
- Calamares графический установщик
- Предустановленные драйверы и утилиты
- Русская локализация
