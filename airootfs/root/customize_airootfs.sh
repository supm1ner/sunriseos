#!/usr/bin/env bash

set -e -u

# Настройка локали
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8/ru_RU.UTF-8/' /etc/locale.gen
locale-gen

# Разрешаем wheel группе использовать sudo БЕЗ пароля для live системы
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

# Создание пользователя live
if ! id -u live > /dev/null 2>&1; then
    useradd -m -G wheel -s /bin/bash live
fi
echo "live:live" | chpasswd
echo "root:root" | chpasswd

# Включаем необходимые сервисы
systemctl enable NetworkManager
if systemctl list-unit-files | grep -q gdm.service; then
    systemctl enable gdm
fi

# Автологин для live пользователя (если GDM установлен)
if [ -d /usr/share/gdm ]; then
    mkdir -p /etc/gdm
    cat > /etc/gdm/custom.conf << 'EOF'
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=live
EOF
fi

# Создаем desktop entry для archinstall
mkdir -p /home/live/Desktop
cat > /home/live/Desktop/install.desktop << 'EOF'
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

# Разблокируем root аккаунт
passwd -u root
