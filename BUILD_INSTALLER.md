# Сборка установщика SunriseOS

## Требования

- Rust и Cargo
- GTK4 и libadwaita

## Установка зависимостей

```bash
sudo pacman -S rust cargo gtk4 libadwaita
```

## Сборка

```bash
cd installer
cargo build --release
```

Бинарник будет в `installer/target/release/sunriseos-installer`

## Автоматическая сборка и копирование

```bash
cd installer
chmod +x build.sh
./build.sh
```

Это соберет установщик и скопирует его в `airootfs/usr/local/bin/`

## Использование

После сборки ISO, в live-системе на рабочем столе будет иконка "Install SunriseOS" которая запустит графический установщик.

## Особенности установщика

- Простой GUI на GTK4/libadwaita
- Автоматическая разметка диска (GPT + EFI)
- Установка базовой системы с GNOME
- Настройка пользователя и hostname
- Установка GRUB загрузчика

## Альтернатива

Если графический установщик не работает, используй archinstall (иконка на рабочем столе).
