# Исправление ошибки "Failed to start Switch Root"

## Что было исправлено:

### 1. Добавлены критические пакеты в packages.x86_64:
- `mkinitcpio` - генератор initramfs
- `mkinitcpio-archiso` - хуки для archiso
- `arch-install-scripts` - скрипты установки
- `squashfs-tools` - для работы со сжатой файловой системой

### 2. Создана конфигурация mkinitcpio:
- Файл: `airootfs/etc/mkinitcpio.conf.d/archiso.conf`
- Добавлены необходимые HOOKS для archiso

### 3. Обновлены параметры загрузки:
- Добавлен параметр `copytoram=n` во все конфигурации загрузчиков
- Это предотвращает копирование всей системы в RAM

### 4. Расширены режимы загрузки в profiledef.sh:
- Добавлена поддержка BIOS eltorito
- Добавлена поддержка UEFI eltorito
- Улучшена совместимость с разными системами

## Как пересобрать ISO:

```bash
# Очистить предыдущую сборку
sudo rm -rf work/ out/

# Пересобрать ISO
sudo ./build.sh
```

## Если проблема сохраняется:

### Вариант 1: Уменьшить размер cow_spacesize
Отредактируй файлы загрузчиков и измени `cow_spacesize=4G` на `cow_spacesize=2G`

### Вариант 2: Добавить debug параметры
Добавь в параметры загрузки:
```
debug systemd.log_level=debug systemd.log_target=console
```

### Вариант 3: Проверить метку диска
Убедись что метка ISO совпадает с параметром `archisolabel`:
```bash
# После записи на USB проверь:
sudo blkid /dev/sdX
```

## Тестирование в QEMU:

```bash
# Установи QEMU если нет
sudo pacman -S qemu-full

# Запусти ISO для теста
qemu-system-x86_64 -enable-kvm -m 4096 -cdrom out/sunriseos-*.iso -boot d
```

## Дополнительные параметры загрузки для отладки:

Если система не загружается, попробуй добавить при загрузке (нажми 'e' в GRUB):
- `nomodeset` - отключить KMS
- `copytoram` - скопировать в RAM (требует 4GB+ RAM)
- `cow_spacesize=2G` - уменьшить размер overlay
- `debug` - включить отладочный вывод
