# PLAN: Кастомизация XP и Reputation полос

## Статус: 📝 ПЛАНИРОВАНИЕ

## Цель
Добавить настройки ширины, высоты и текстуры для XP Bar и Reputation Bar. Каждая полоса имеет раздельные настройки.

## Значения по умолчанию
- Ширина: 512
- Высота: 14
- Текстура: `Interface\TARGETINGFRAME\UI-StatusBar` ("Standard")

## Функциональные требования

### 1. Ширина полосы (Width)
- Диапазон: 100 - 800
- Шаг: 10
- По умолчанию: 512
- Применяется мгновенно при изменении

### 2. Высота полосы (Height)
- Диапазон: 5 - 50
- Шаг: 1
- По умолчанию: 14
- Применяется мгновенно при изменении

### 3. Текстура (Texture)
- Тип: выпадающий список (dropdown)
- Доступные текстуры TBC:
  - `Interface\TARGETINGFRAME\UI-StatusBar` → "Standard"
  - `Interface\RAIDFRAME\Raid-Bar-Hp-Fill` → "Raid"
  - `Interface\CastingBar\UI-CastingBar-Standard` → "Casting"
  - `Interface\PaperDollInfoFrame\UI-Character-Skills-Bar` → "Skills"
  - `Interface\TargetingFrame\UI-TargetingFrame-BarFill` → "Targeting"
- Названия текстур остаются на английском
- Текстура применяется к StatusBar и фону

## Техническая реализация

### Файлы для изменения

#### 1. specialBars/XPBar.lua
**Изменения в defaults:**
```lua
local defaults = { profile = Bartender4:Merge({
    enabled = true,
    showtext = true,
    showrested = true,
    width = 512,        -- NEW
    height = 14,        -- NEW
    texture = "Interface\\TARGETINGFRAME\\UI-StatusBar",  -- NEW
}, Bartender4.Bar.defaults) }
```

**Изменения в PerformLayout():**
```lua
function XPBar:PerformLayout()
    local width = self.config.width or 512
    local height = self.config.height or 14
    self:SetSize(width, height)
    self.status:SetAllPoints(self)
    -- Apply texture
    self.status:SetStatusBarTexture(self.config.texture)
    self.bg:SetTexture(self.config.texture)
    -- Show/hide text
    if self.config.showtext then
        self.text:Show()
    else
        self.text:Hide()
    end
end
```

**Новые методы:**
```lua
function XPBar:GetWidth()
    return self.config.width
end

function XPBar:SetWidth(width)
    self.config.width = width
    self:PerformLayout()
end

function XPBar:GetHeight()
    return self.config.height
end

function XPBar:SetHeight(height)
    self.config.height = height
    self:PerformLayout()
end

function XPBar:GetTexture()
    return self.config.texture
end

function XPBar:SetTexture(texture)
    self.config.texture = texture
    self:PerformLayout()
end
```

#### 2. specialBars/XPBarOptions.lua
**Добавить маппинг опций (order 40-60):**
```lua
local optionMap = {
    width = "Width",
    height = "Height",
    texture = "Texture",
}
```

**Добавить опции:**
```lua
-- Width (order 40)
self.optionobject:AddElement("general", "width", {
    type = "range",
    order = 40,
    name = L["Bar Width"],
    desc = L["Set the width of the bar."],
    min = 100,
    max = 800,
    step = 10,
    get = optGetter,
    set = optSetter,
})

-- Height (order 50)
self.optionobject:AddElement("general", "height", {
    type = "range",
    order = 50,
    name = L["Bar Height"],
    desc = L["Set the height of the bar."],
    min = 5,
    max = 50,
    step = 1,
    get = optGetter,
    set = optSetter,
})

-- Texture (order 60)
local barTextures = {
    ["Interface\\TARGETINGFRAME\\UI-StatusBar"] = "Standard",
    ["Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill"] = "Raid",
    ["Interface\\CastingBar\\UI-CastingBar-Standard"] = "Casting",
    ["Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"] = "Skills",
    ["Interface\\TargetingFrame\\UI-TargetingFrame-BarFill"] = "Targeting",
}

self.optionobject:AddElement("general", "texture", {
    type = "select",
    order = 60,
    name = L["Bar Texture"],
    desc = L["Select the texture for the bar."],
    values = barTextures,
    get = optGetter,
    set = optSetter,
})
```

**Примечание:** Нужно добавить локальные функции `optGetter` и `optSetter` аналогично `BagBarOptions.lua`, или использовать подход с `AddElement` и прямыми `get/set` функциями.

#### 3. specialBars/ReputationBar.lua
Аналогичные изменения как в XPBar.lua:
- Добавить `width`, `height`, `texture` в defaults
- Обновить `PerformLayout()` для использования config значений
- Добавить методы `GetWidth/SetWidth`, `GetHeight/SetHeight`, `GetTexture/SetTexture`

#### 4. specialBars/ReputationBarOptions.lua
Аналогичные изменения как в XPBarOptions.lua:
- Добавить `width`, `height`, `texture` в defaults
- Добавить три опции (width, height, texture) через `AddElement`
- Использовать тот же список текстур

### 5. Локализация

**Новые строки (добавить в код для Babelfish):**
```lua
L["Bar Width"] = true
L["Bar Height"] = true
L["Bar Texture"] = true
L["Set the width of the bar."] = true
L["Set the height of the bar."] = true
L["Select the texture for the bar."] = true
```

**Русская локализация (locale/ruRU.lua):**
```lua
L["Bar Width"] = "Ширина полосы"
L["Bar Height"] = "Высота полосы"
L["Bar Texture"] = "Текстура полосы"
L["Set the width of the bar."] = "Установить ширину полосы."
L["Set the height of the bar."] = "Установить высоту полосы."
L["Select the texture for the bar."] = "Выбрать текстуру для полосы."
```

### Порядок опций в UI

```
General Settings (порядок настроек):
  1.  Enabled (toggle)
  5.  Show/Hide (select: alwaysshow/alwayshide/combatshow/combathide)
  10. Bar Style & Layout (header)
  20. Alpha (range 0.1-1)
  30. Scale (range 0.1-2)
  40. Bar Width (range 100-800, step 10)      ← NEW
  50. Bar Height (range 5-50, step 1)         ← NEW
  60. Bar Texture (select: Standard/Raid/Casting/Skills/Target) ← NEW
  81. Show Text (toggle)
  82. Show Rested / Auto Hide (toggle)
  100. Fade Out (toggle)
  101. Fade Out Alpha (range 0-1)
  102. Fade Out Delay (range 0-1)
```

## Архитектурные нюансы

### Интеграция с barPrototype
Текущий `barPrototype/Options.lua` предоставляет базовые опции через `GetOptionObject()`. Наши новые опции (width, height, texture) будут добавлены через `AddElement()` в существующую структуру.

### Работа с optionMap
В `XPBarOptions.lua` нужно либо:
- **Вариант A:** Добавить `width`, `height`, `texture` в `optionMap` и использовать `optGetter/optSetter`
- **Вариант B:** Использовать прямые `get/set` функции как в текущих showtext/showrested

**Рекомендую Вариант B** — он проще и не требует модификации barPrototype/Options.lua:
```lua
get = function() return self.db.profile.width end,
set = function(info, value)
    self.db.profile.width = value
    self:ApplyConfig()
end,
```

### Сохранение настроек
Все настройки сохраняются автоматически через AceDB-3.0 в `Bartender4DB` профиль.

## Чек-лист реализации

### Код
- [ ] specialBars/XPBar.lua — defaults, PerformLayout, Get/Set методы
- [ ] specialBars/XPBarOptions.lua — добавить 3 опции (width, height, texture)
- [ ] specialBars/ReputationBar.lua — defaults, PerformLayout, Get/Set методы
- [ ] specialBars/ReputationBarOptions.lua — добавить 3 опции (width, height, texture)

### Локализация
- [ ] Добавить L[] вызовы в коде для новых строк
- [ ] locale/ruRU.lua — добавить русский перевод
- [ ] locale/enUS.lua — будет обновлен через Babelfish (или вручную)

### Тестирование
- [ ] XP Bar меняет ширину при изменении слайдера
- [ ] XP Bar меняет высоту при изменении слайдера
- [ ] XP Bar меняет текстуру при выборе из dropdown
- [ ] Reputation Bar — аналогичные проверки
- [ ] Настройки сохраняются после /reload
- [ ] Настройки сохраняются при смене профиля
- [ ] Разные профили могут иметь разные размеры и текстуры

## Следующий шаг
После утверждения плана — приступаем к реализации.
