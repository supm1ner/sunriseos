#!/usr/bin/env bash

# НЕ используем set -e чтобы скрипт не падал на ошибках
set -u

# Настройка локали
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8/ru_RU.UTF-8/' /etc/locale.gen
locale-gen

# Простой способ - устанавливаем пустой пароль для root
passwd -d root

# Разрешаем wheel группе использовать sudo БЕЗ пароля для live системы
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# Создание пользователя live
if ! id -u live > /dev/null 2>&1; then
    useradd -m -G wheel -s /bin/bash live
fi
echo "live:live" | chpasswd

# Включаем необходимые сервисы
systemctl enable NetworkManager
systemctl enable gdm 2>/dev/null || true

# Автологин для live пользователя
mkdir -p /etc/gdm
cat > /etc/gdm/custom.conf << 'EOF'
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=live
EOF

# Создаем desktop entry для установщиков
mkdir -p /home/live/Desktop

# SunriseOS Installer (Rust GUI)
cat > /home/live/Desktop/installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Install SunriseOS
Name[ru]=Установить SunriseOS
Comment=SunriseOS graphical installer
Comment[ru]=Графический установщик SunriseOS
Exec=pkexec /usr/local/bin/sunriseos-installer
Icon=system-software-install
Terminal=false
StartupNotify=true
Categories=System;
EOF

# Archinstall (text-based backup)
cat > /home/live/Desktop/archinstall.desktop << 'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Install SunriseOS (Terminal)
Name[ru]=Установить SunriseOS (Терминал)
Comment=Archinstall - text installer
Comment[ru]=Archinstall - текстовый установщик
Exec=gnome-terminal -- sudo archinstall
Icon=utilities-terminal
Terminal=false
StartupNotify=true
Categories=System;
EOF

chmod +x /home/live/Desktop/installer.desktop 2>/dev/null || true
chmod +x /home/live/Desktop/archinstall.desktop 2>/dev/null || true

# Настройка обоев для live пользователя
mkdir -p /home/live/.config

# Применяем настройки
chown -R live:live /home/live 2>/dev/null || true

# Настройка часового пояса
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

echo "Customize script completed"
