#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="sunriseos"
iso_label="SUNRISEOS_$(date +%Y%m)"
iso_publisher="SunriseOS <https://github.com/supm1ner/sunriseos>"
iso_application="SunriseOS Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-ia32.systemd-boot.esp' 'uefi-x64.systemd-boot.esp' 'uefi-ia32.systemd-boot.eltorito' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/.xinitrc"]="0:0:755"
  ["/root/.zlogin"]="0:0:755"
  ["/home/live/.xinitrc"]="1000:1000:755"
  ["/home/live/.zlogin"]="1000:1000:755"
  ["/usr/local/bin/install-gnome-extensions.sh"]="0:0:755"
  ["/usr/local/bin/sunriseos-installer"]="0:0:755"
)
