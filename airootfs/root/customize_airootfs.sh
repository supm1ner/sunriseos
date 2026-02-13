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

chmod +x /home/live/Desktop/installer.desktop
chmod +x /home/live/Desktop/archinstall.desktop
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

# Включаем расширения GNOME
sudo -u live dbus-launch gsettings set org.gnome.shell disable-user-extensions false 2>/dev/null || true

# Создаем скрипт автозапуска для установки расширений
mkdir -p /home/live/.config/autostart
cat > /home/live/.config/autostart/install-extensions.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Install GNOME Extensions
Exec=/usr/local/bin/install-gnome-extensions.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

chmod +x /usr/local/bin/install-gnome-extensions.sh

chown -R live:live /home/live

# Настройка часового пояса
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Разблокируем root аккаунт
passwd -u root
