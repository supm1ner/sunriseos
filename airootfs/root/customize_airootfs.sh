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

# Создаем desktop entry для установщиков
mkdir -p /home/live/Desktop

# Calamares installer
cat > /home/live/Desktop/calamares.desktop << 'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Install SunriseOS (Graphical)
Name[ru]=Установить SunriseOS (Графический)
Comment=Calamares installer
Comment[ru]=Установщик Calamares
Exec=sudo -E calamares
Icon=calamares
Terminal=false
StartupNotify=true
Categories=System;
EOF

# Archinstall (text-based)
cat > /home/live/Desktop/install.desktop << 'EOF'
[Desktop Entry]
Type=Application
Version=1.0
Name=Install SunriseOS (Terminal)
Name[ru]=Установить SunriseOS (Терминал)
Comment=Archinstall - text installer
Comment[ru]=Archinstall - текстовый установщик
Exec=gnome-terminal -- sudo archinstall
Icon=system-software-install
Terminal=false
StartupNotify=true
Categories=System;
EOF

chmod +x /home/live/Desktop/calamares.desktop
chmod +x /home/live/Desktop/install.desktop
chown -R live:live /home/live

# Настройка обоев для live пользователя
mkdir -p /home/live/.config
cat > /home/live/.config/dconf-user.conf << 'EOF'
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/sunriseos/dark.png'
picture-uri-dark='file:///usr/share/backgrounds/sunriseos/dark.png'
picture-options='zoom'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/sunriseos/dark.png'
EOF

# Применяем настройки dconf
sudo -u live dbus-launch gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/sunriseos/dark.png' 2>/dev/null || true
sudo -u live dbus-launch gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/sunriseos/dark.png' 2>/dev/null || true

chown -R live:live /home/live

# Настройка часового пояса
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Разблокируем root аккаунт
passwd -u root
