# Установка Calamares

Calamares не доступен в официальных репозиториях Arch. Есть несколько вариантов:

## Вариант 1: Использовать archinstall (встроенный в Arch)

Вместо Calamares можно использовать `archinstall` - официальный установщик Arch:

```bash
# Добавить в packages.x86_64
archinstall
```

## Вариант 2: Собрать Calamares из AUR

На машине для сборки:

```bash
# Установить yay (AUR helper)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Собрать calamares
yay -S calamares

# Скопировать пакет в кастомный репозиторий
```

## Вариант 3: Использовать готовый пакет из EndeavourOS

EndeavourOS предоставляет готовый Calamares:

```bash
# Добавить в pacman.conf:
[endeavouros]
SigLevel = PackageRequired
Server = https://mirror.alpix.eu/endeavouros/repo/$repo/$arch
```

## Рекомендация

Для простоты используй `archinstall` - он официальный и работает из коробки.
