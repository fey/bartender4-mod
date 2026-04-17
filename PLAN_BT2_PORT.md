# PLAN: Порт полезных функций из Bartender2 в Bartender4

## Статус: 📝 ПЛАНИРОВАНИЕ

## Контекст
В репозитории есть исторический код `Bartender2/` (в gitignore), который содержит набор модулей и UX-идей.
Цель — выбрать и перенести только те функции, которые дают практическую ценность в текущей архитектуре BT4 (Ace3, модульные `barPrototype`/`buttonBarPrototype`/`actionBar`/`specialBars`).

## Что уже есть в BT4 (портировать не нужно)
- Modifier paging (`Ctrl/Alt/Shift`) и state-based switching: `actionBar/States.lua`, `actionBar/StatesOptions.lua`.
- Stance/form paging (включая `prowl`, `shadowform`): `actionBar/States.lua`, дефолты в `actionBar/ActionBars.lua`.
- Fade/alpha/rows/padding/show-hide/tooltip/hotkey: `barPrototype/Options.lua`, `buttonBarPrototype/Options.lua`, `Options.lua`.
- Launcher/конфиг через LDB вместо FuBar: `Bartender4.lua`.

## Кандидаты на порт (приоритет)
1. **P1 — Snapping / Alignment (прилипание баров)**
   - Источник: `Bartender2/Bartender2/StickyFrames.lua`.
   - Обоснование: напрямую закрывает старый TODO `Alignment Menu` (`TODO.txt`).
   - Ценность: быстрый и удобный layout без ручного пиксель-хантинга.

2. **P2 — Friendly Target Page**
   - Источник: `Bartender2/Bartender2_Pagemaster/Pagemaster.lua`.
   - Суть: переключение страницы при friendly target.
   - Ценность: situational usability для хил/саппорт профилей.

3. **P2 — Hunter Auto Melee/Ranged Page**
   - Источник: `Bartender2/Bartender2_HunterBars/HunterBars.lua`.
   - Суть: автопереключение страницы по дистанции/режиму боя.
   - Ценность: класс-специфический QoL для Hunter.

4. **P3 — BindingSwap (опционально)**
   - Источник: `Bartender2/Bartender2_BindingSwap/BindingSwap.lua`.
   - Суть: быстрый swap биндов на выбранную панель.
   - Риск: пересечение с текущим LibKeyBound workflow в BT4.

## Что не переносим
- `DruidBar`, `ShadowBar` как отдельные модули (дублируют state system BT4).
- `FuBartender2` (устаревшая FuBar-модель).
- `n52` (слишком узкий legacy-кейс).
- `Circled` как отдельный тяжелый skin-модуль (в BT4 уже есть ButtonFacade-путь).

## План реализации

### Этап 1 (P1): Snapping / Alignment
- Добавить в `barPrototype` поддержку snap-перемещения при unlock/drag.
- Ввести опции:
  - `Enable Snapping` (toggle)
  - `Snap Distance` (range, например 4–24)
  - `Snap To Screen` (toggle)
  - `Snap To Other Bars` (toggle)
- Интегрировать в текущую механику `Bar:Unlock()`/drag callbacks без ломки secure/lock логики.
- Обновить локализацию ключей для новых опций.

### Этап 2 (P2): Friendly Target Page
- Расширить state config в `actionBar/States.lua` и `actionBar/StatesOptions.lua`.
- Добавить опцию выбора страницы (`0 = off`, `1..10 = page`, `-1 = hide`, если применимо по текущей модели).
- Приоритет в цепочке условий — ниже modifier states, выше default state (по аналогии с существующей логикой приоритетов).

### Этап 3 (P2): Hunter Auto Page
- Вариант A: отдельный модуль в `actionBar/` с class guard.
- Вариант B: расширение state-механики для hunter-specific rule.
- Добавить enable/disable и target page в опциях.
- Проверить поведение в combat lockdown и при смене цели/дистанции.

### Этап 4 (P3): BindingSwap (опциональный)
- Спроектировать как отдельную утилиту/режим, не ломающий LibKeyBound.
- Добавить explicit предупреждение в UI о перезаписи текущих биндов.
- Реализовывать только после стабилизации этапов 1–3.

## Риски и ограничения
- Snapping может конфликтовать с текущим drag UX, если не учитывать scale/anchor каждого бара.
- Любые binding-операции требуют аккуратного обращения с `SaveBindings` и режимами боя.
- Для TBC клиента важно не тащить retail API и не ломать secure state driver поведение.

## Ручная проверка (in-game)
1. `/bt4` → unlock → drag: бары корректно прилипают по настройкам.
2. Проверить snapping при разных `scale`/`alpha`/`fade` и после `/reload`.
3. Проверить priority state switching: modifiers → class/target conditions → default.
4. Hunter: корректный возврат на базовую страницу при смене дистанции/цели.
5. Профили: все новые настройки раздельно сохраняются.

## Связь с существующим TODO
- Закрывает пункт: `Alignment Menu` из `TODO.txt`.
- Не конфликтует с реализованным планом `PLAN.md` (XP/Reputation).
- Может быть дополнен после завершения `PLAN_CUSTOMIZATION.md`.
