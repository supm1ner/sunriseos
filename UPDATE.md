# Инструкция по обновлению

## На Linux машине выполни:

```bash
cd sunriseos
git pull origin main
```

Если видишь ошибку про локальные изменения:

```bash
git stash
git pull origin main
```

Или полный сброс к последней версии:

```bash
git fetch origin
git reset --hard origin/main
```

## Проверь что файлы обновились:

```bash
# Должен быть syslinux в списке
grep syslinux packages.x86_64

# Должно быть: bootmodes=('bios.syslinux' 'uefi-x64.grub.esp' 'uefi-x64.grub.eltorito')
grep bootmodes profiledef.sh
```

## Запусти сборку:

```bash
sudo ./build.sh
```
