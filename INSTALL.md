# Инструкция по сборке SunriseOS

## Подготовка системы для сборки

Для сборки ISO образа нужна система на базе Arch Linux. Можно использовать:
- Arch Linux
- Manjaro
- EndeavourOS
- Любой другой Arch-based дистрибутив

## Шаг 1: Установка зависимостей

```bash
sudo pacman -Syu
sudo pacman -S archiso git
```

## Шаг 2: Клонирование репозитория

```bash
git clone https://github.com/supm1ner/sunriseos.git
cd sunriseos
```

## Шаг 3: Сборка ISO

```bash
sudo ./build.sh
```

Процесс сборки займет 20-60 минут в зависимости от скорости интернета и мощности системы.

## Шаг 4: Результат

После успешной сборки ISO файл будет находиться в директории `out/`:
```
out/sunriseos-YYYY.MM.DD-x86_64.iso
```

## Запись на USB

### Linux:
```bash
sudo dd if=out/sunriseos-*.iso of=/dev/sdX bs=4M status=progress && sync
```
Замените `/dev/sdX` на ваше USB устройство (например `/dev/sdb`)

### Windows:
Используйте Rufus или Etcher для записи ISO на USB

## Возможные проблемы

### Ошибка: "command not found: mkarchiso"
Установите archiso: `sudo pacman -S archiso`

### Ошибка: "Permission denied"
Запускайте build.sh с sudo: `sudo ./build.sh`

### Недостаточно места
Убедитесь что есть минимум 10GB свободного места

## Тестирование в виртуальной машине

```bash
# Установите QEMU
sudo pacman -S qemu-full

# Запустите ISO
qemu-system-x86_64 -enable-kvm -m 4096 -cdrom out/sunriseos-*.iso
```

## Структура проекта

```
sunriseos/
├── airootfs/              # Файлы live-системы
│   ├── etc/              # Конфигурационные файлы
│   └── root/             # Скрипты настройки
├── grub/                 # Конфигурация GRUB
├── syslinux/             # Конфигурация Syslinux
├── profiledef.sh         # Определение профиля
├── packages.x86_64       # Список пакетов
├── pacman.conf           # Конфигурация pacman
└── build.sh              # Скрипт сборки
```
