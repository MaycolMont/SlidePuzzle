# Godot SlidePuzzle Project

## Project Type
Godot 4.6, GL Compatibility renderer. Viewport 250x400 (portrait). Opens in Godot Editor, not a web project.

## Running
Open `project.godot` in Godot Editor → F5. Entry scene is `scenes/main.tscn` (menu), **not** `game.tscn`.

## Scene Flow
`main.tscn` → `select_menu.tscn` (pick image + grid size) → `game.tscn` → dynamically instantiates `board.tscn` → spawns `piece.tscn` children.

## Autoloads (Singletons)
- `Global` (`scripts/autoloads/global.gd`) — game state, texture/grid selection, save/load top 5 times per grid size
- `Config` (`config/Config.gd`) — constants, DEBUG_MODE toggle

## Key Scripts
- `scripts/game.gd` — game controller, handles win popup, escape→pause menu
- `scripts/board.gd` — Board class_name, generates pieces, tracks free slot, detects solved state
- `scripts/piece.gd` — Piece class_name (extends Area2D), click-to-move via RayCast2D, multi-push support
- `scripts/utils/utils.gd` — Utils class_name (NOT an autoload), static helpers for time formatting and random vectors
- `config/Config.gd:26` — `DEBUG_MODE = true`; preloads `DebugConfig.gd` at startup
- `config/DebugConfig.gd` — when DEBUG_MODE, skips menu: loads `snowman.png` with 3x3 grid

## Paths
- Images: `res://assets/sprites/images/` (png/jpg/svg supported)
- Save: `user://save_game.dat` (Dictionary of grid_size → [top 5 times])
- Scenes: `scenes/main.tscn` (menu), `scenes/game.tscn` (gameplay), `scenes/board.tscn`, `scenes/piece.tscn`

## Testing
`tests/test.gd` is a stub (prints a node, does nothing). No test framework configured. Verify by running in editor.
