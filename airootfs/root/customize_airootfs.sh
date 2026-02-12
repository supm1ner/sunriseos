#!/usr/bin/env bash

set -e -u

# Включаем необходимые сервисы
systemctl enable NetworkManager
systemctl enable gdm || echo "GDM not found, skipping..."

# Настройка локали
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8/ru_RU.UTF-8/' /etc/locale.gen
locale-gen

# Создание пользователя live
useradd -m -G wheel -s /bin/bash live || echo "User live already exists"
echo "live:live" | chpasswd
echo "root:root" | chpasswd

# Разрешаем wheel группе использовать sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Автологин для live пользователя (если GDM установлен)
if [ -d /etc/gdm ]; then
    cat > /etc/gdm/custom.conf << EOF
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=live
EOF
fi

# Создаем desktop entry для archinstall
mkdir -p /home/live/Desktop
cat > /home/live/Desktop/install.desktop << EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Install SunriseOS
Name[ru]=Установить SunriseOS
Comment=System installer
Comment[ru]=Установщик системы
Exec=gnome-terminal -- sudo archinstall
Icon=system-software-install
Terminal=false
StartupNotify=true
Categories=System;
EOF

chmod +x /home/live/Desktop/install.desktop
chown -R live:live /home/live

# Настройка часового пояса
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
