# GNOME Расширения в SunriseOS

## Предустановленные инструменты

- Extension Manager - графический менеджер расширений
- gnome-browser-connector - для установки через браузер

## Рекомендуемые расширения

Эти расширения можно установить через Extension Manager или https://extensions.gnome.org:

1. **Blur my Shell** - размытие фона панели и обзора
2. **Burn My Windows** - анимации открытия/закрытия окон
3. **Compiz alike magic lamp effect** - эффект при сворачивании
4. **Compiz windows effect** - эффекты покачивания окон
5. **Dash2Dock Animated** - анимированный док
6. **Desktop Cube** - 3D куб рабочих столов

## Установка расширений

### Способ 1: Extension Manager (рекомендуется)
```bash
# Запустить Extension Manager из меню приложений
# Найти нужное расширение и нажать Install
```

### Способ 2: Через браузер
1. Открыть Firefox
2. Перейти на https://extensions.gnome.org
3. Установить browser connector (если попросит)
4. Найти расширение и нажать ON

### Способ 3: Вручную из AUR
```bash
yay -S gnome-shell-extension-blur-my-shell
yay -S gnome-shell-extension-dash-to-dock
```

## Включение расширений

После установки:
1. Открыть Extension Manager
2. Включить нужные расширения
3. Настроить через иконку шестеренки

## Автозапуск

При первом входе в систему автоматически запустится скрипт установки популярных расширений.
