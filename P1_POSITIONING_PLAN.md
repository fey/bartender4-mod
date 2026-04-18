# P1 Positioning Plan

## Goal
Implement practical bar positioning improvements in small, testable features:

1. Positioning config model
2. Clamp to screen
3. Bar-to-bar snapping (edge)
4. Axis alignment (center lines)
5. Snap prioritization and stability
6. Alignment options UI
7. Position persistence and scale behavior
8. Localization updates
9. In-game validation pass

## Feature Breakdown

### F1 - Positioning Config Model
- Add per-bar config keys for positioning behavior:
  - `snapping`
  - `snapDistance`
  - `snapPadding`
  - `clampToScreen`
- Keep defaults backward-compatible for existing profiles.

### F2 - Clamp To Screen
- Prevent bars from being moved outside the visible screen area.
- Apply clamping through the shared bar prototype so all bars inherit it.
- Persist and load positions normally.

### F3 - Snap To Other Bars (Edges)
- On drag stop, evaluate nearby Bartender4 bars.
- Snap to the closest valid edge-to-edge match within `snapDistance`.

### F4 - Axis Alignment
- Add center X / center Y alignment as additional snap candidates.

### F5 - Snap Priority Rules
- Resolve ambiguous candidates with deterministic rules.
- Prefer stable outcomes to avoid jumping between candidates.

### F6 - Alignment UI
- Replace current Alignment TODO description with active controls.
- Expose per-bar settings for snapping and clamping.

### F7 - Persistence + Scale
- Keep current position save/load flow.
- Validate behavior with different bar scales.

### F8 - Localization
- Add localization keys for new Alignment controls.
- Regenerate locale key list through `locale/Babelfish.lua` workflow.

### F9 - In-Game Validation
- Manual checks:
  - unlock + drag near screen edges
  - drag near other bars to snap
  - `/reload` position persistence
  - action/special bars consistency

## Implementation Order
1. F1
2. F2
3. F3
4. F4
5. F5
6. F6
7. F8
8. F9

## Current Status
- [x] F1 Positioning Config Model
- [x] F2 Clamp To Screen
- [x] F3 Snap To Other Bars (Edges)
- [x] F4 Axis Alignment
- [x] F5 Snap Priority Rules
- [x] F6 Alignment UI
- [ ] F7 Persistence + Scale
- [ ] F8 Localization
- [ ] F9 In-Game Validation
