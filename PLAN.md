# PLAN: XP и Reputation полосы

## Статус: ✅ РЕАЛИЗОВАНО

## Цель
Добавить в Bartender4 две независимые полосы: `XP Bar` и `Reputation Bar`, каждая со своими настройками, включением/выключением и перемещением.

## Что было реализовано

- ✅ `specialBars/XPBar.lua` — модуль полосы опыта с StatusBar, отслеживанием XP и rested XP
- ✅ `specialBars/XPBarOptions.lua` — настройки полосы опыта (вкл/выкл, текст, отдых)
- ✅ `specialBars/ReputationBar.lua` — модуль полосы репутации с автоскрытием
- ✅ `specialBars/ReputationBarOptions.lua` — настройки полосы репутации (вкл/выкл, текст, автоскрытие)
- ✅ `specialBars/SpecialBars.xml` — добавлены новые файлы в load order
- ✅ `locale/enUS.lua` — добавлены все необходимые строки локализации
- ✅ `locale/ruRU.lua` — добавлена русская локализация для новых строк
- ✅ `locale/Babelfish.lua` — обновлен список файлов для генерации локализаций

## План реализации

1. **Новые модули specialBars**
   - Создать `specialBars/XPBar.lua`.
   - Создать `specialBars/ReputationBar.lua`.
   - Реализовать их как отдельные `Bartender4:NewModule(...)` по паттерну существующих специальных баров.

2. **Опции для каждого модуля**
   - Создать `specialBars/XPBarOptions.lua`.
   - Создать `specialBars/ReputationBarOptions.lua`.
   - Использовать `Bar:GetOptionObject()` (как у `MicroMenu`), чтобы получить стандартные настройки бара (позиция, scale, alpha, show/hide, fade и т.д.).
   - Добавить минимум специфичных опций:
     - XP: `showText`, `showRested`.
     - Reputation: `showText`, `autoHideWhenNoWatchedFaction`.

3. **Подключение в load order**
   - Обновить `specialBars/SpecialBars.xml`:
     - добавить `XPBar.lua`, `XPBarOptions.lua`;
     - добавить `ReputationBar.lua`, `ReputationBarOptions.lua`;
     - сохранить порядок: сначала модуль, затем его options.

4. **UI и обновление данных**
   - В каждом модуле создать основной бар на базе `Bartender4.Bar:Create(...)`.
   - Внутри разместить `StatusBar` + фон + текст (по настройке).
   - XPBar:
     - использовать `UnitXP("player")`, `UnitXPMax("player")`, `GetXPExhaustion()`;
     - слушать `PLAYER_XP_UPDATE`, `UPDATE_EXHAUSTION`.
   - ReputationBar:
     - использовать `GetWatchedFactionInfo()`;
     - слушать `UPDATE_FACTION`;
     - скрывать полосу, если нет отслеживаемой фракции (при включенной опции auto-hide).

5. **Интеграция с системой настроек Bartender4**
   - Зарегистрировать namespace через `Bartender4.db:RegisterNamespace(...)`.
   - Управлять enable/disable через `SetEnabledState` и `ToggleModule`.
   - Регистрировать категории опций через `Bartender4:RegisterBarOptions("XPBar", ...)` и `Bartender4:RegisterBarOptions("ReputationBar", ...)`.

6. **Локализация**
   - Добавить новые строки через `L["..."]` в коде.
   - Не править `locale/enUS.lua` вручную.
   - После добавления ключей прогнать `locale/Babelfish.lua` для регенерации `enUS.lua` и обновления остальных locale-файлов.

7. **Проверка в игре (ручная)**
   - `/bt4`: есть отдельные категории `XP Bar` и `Reputation Bar`.
   - Каждая полоса независимо включается/выключается и двигается.
   - XP полоса обновляется при получении опыта; rested отображается корректно.
   - Reputation полоса обновляется при изменении репутации; корректно скрывается, если не выбрана watched faction.
   - Проверить поведение после `Reload UI` и смены профиля.

## Файлы, которые были созданы/изменены

- `specialBars/SpecialBars.xml` *(modified)*
- `specialBars/XPBar.lua` *(new)*
- `specialBars/XPBarOptions.lua` *(new)*
- `specialBars/ReputationBar.lua` *(new)*
- `specialBars/ReputationBarOptions.lua` *(new)*
- `locale/enUS.lua` *(modified)*
- `locale/ruRU.lua` *(modified)*
- `locale/Babelfish.lua` *(modified)*

## Инструкция по тестированию в игре

1. Скопируйте/обновите аддон в папку `Interface\AddOns\Bartender4`
2. Зайдите в игру или выполните `/reload`
3. Откройте настройки: `/bt4`, `/bt` или `/bar`
4. В дереве настроек должны появиться:
   - **XP Bar** (порядок 31)
   - **Reputation Bar** (порядок 32)
5. Проверьте функционал:
   - Включение/выключение каждой полосы
   - Перемещение полос (unlock → drag → lock)
   - Настройка прозрачности, масштаба, fade
   - **XP Bar**: текст показывает текущий XP / максимальный XP + процент + rested (если включено)
   - **Reputation Bar**: текст показывает фракцию, уровень отношений, прогресс; автоскрытие когда нет отслеживаемой фракции
6. Смените профиль в настройках Bartender4 — полосы должны сохранить свои настройки
