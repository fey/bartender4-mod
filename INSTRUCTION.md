# Bartender4 Positioning Instruction

## Quick Start
- Open settings with `/bt4` (or `/bt`, `/bar`).
- Unlock bars: top-level `Lock` toggle off.
- Open any bar settings: `Bars -> <Bar Name/Number> -> Alignment`.
- Move bars by dragging their green/red overlay while unlocked.
- Lock bars back after setup.

## Alignment Options (per bar)
- `Enable Snapping`: enables snap logic while dragging.
- `Snap Distance`: edge-to-edge snap threshold (pixels).
- `Center Snap Distance`: center alignment threshold (pixels), usually larger than edge snap.
- `Snap Padding`: additional gap for edge snap.
- `Clamp to Screen`: keeps bar inside screen bounds.

## Recommended Baseline Preset
- `Enable Snapping`: ON
- `Snap Distance`: `12`
- `Center Snap Distance`: `24`
- `Snap Padding`: `0`
- `Clamp to Screen`: ON

## Setup Checklist
- Unlock bars.
- Enable `Clamp to Screen` on bars you move often.
- Set `Snap Distance` first (8-14 is a safe range).
- Set `Center Snap Distance` higher than edge snap (18-30 usually feels good).
- Move bars near each other and release mouse to apply snap.
- Run `/reload` and verify positions persist.
- Enter combat and verify no unexpected movement behavior.

## QA Checklist (manual)
- Drag a bar to each screen edge: bar stays visible (`Clamp to Screen` ON).
- Drag a bar near another bar side: edge snap triggers.
- Drag a bar above/below another bar with slight horizontal offset: center X alignment triggers.
- Drag a bar left/right of another bar with slight vertical offset: center Y alignment triggers.
- Verify mixed case: one axis edge snap + second axis center align.
- Verify no random long-distance snap when bars are far apart.
- Verify layout after `/reload`.

## Keybinding Mode (`/kb`)
- Run `/kb` to enter keybinding mode for Bartender buttons.
- Hover or click the action button you want to bind, then press the desired key.
- Press `ESC` while targeting a button to clear its binding.
- Right-click a button to clear its current binding.
- Run `/kb` again (or close the mode UI) to finish binding.

## FAQ

### Как сделать набор баров вплотную, без прорези между кнопками?
1. For each involved bar, set `Bars -> <Bar> -> Alignment -> Snap Padding = 0`.
2. In button bars, set `Bars -> <Bar> -> General Settings -> Padding = 0`.
3. Keep `Snap Distance` around `10-14` for easy edge snap.
4. Drag one bar to another until it snaps edge-to-edge, then release.

Note: visual seams can also come from different bar scale/skin/backdrop. If a tiny seam remains, make sure both bars use the same:
- `Scale`
- Button skin/backdrop style
- Row/layout settings

Important for stacked button bars (one above another):
- Snap currently uses bar frame edges, not raw button texture edges.
- Button bars have built-in frame insets, so an apparent gap can remain even at `Snap Padding = 0`.
- For a truly flush button-to-button stack, set `Snap Padding = -8`.

### Центрирование ловится слишком слабо
- Increase `Center Snap Distance` (example: 24 -> 28 or 32).

### Бар липнет слишком агрессивно
- Lower `Snap Distance` and/or `Center Snap Distance`.

### Нужно временно отключить прилипания
- Set `Enable Snapping` to OFF for that bar.

### Бар “потерялся” после смены масштаба
- Enable `Clamp to Screen`, then move bar once and release.
- Optionally run `/reload` after final placement.

### Как быстро переназначить клавиши для кнопок?
- Используй `/kb` для входа в режим назначения биндов.
- Наведи/кликни нужную кнопку и нажми новую клавишу.
- `ESC` или ПКМ по кнопке очищает назначение.
- Повтори `/kb`, чтобы выйти из режима.

## Practical Profiles

### Tight grid (compact)
- `Snap Distance`: 12
- `Center Snap Distance`: 24
- `Snap Padding`: 0
- Button `Padding`: 0

### Soft spacing (readable)
- `Snap Distance`: 10
- `Center Snap Distance`: 22
- `Snap Padding`: 2-4
- Button `Padding`: 1-2

### Free placement
- `Enable Snapping`: OFF
- `Clamp to Screen`: ON
