# Godot SlidePuzzle Project

## Project Type
Godot 4.6 project using GL Compatibility renderer. Not a web/JS project - runs in Godot Editor.

## Running the Game
Open `project.godot` in Godot Editor and press F5 (or click Play button).

## Key Files
- `project.godot` - Engine config
- `scenes/game.tscn` - Main game scene
- `scripts/game.gd` - Game controller
- `scripts/board.gd` - Board logic
- `scripts/piece.gd` - Puzzle piece

## Autoloads (Global Singletons)
- `Global` - `scripts/autoloads/global.gd` - Game state, texture, save/load
- `Config` - `config/Config.gd` - Settings (DEBUG_MODE=true by default)

## Code Quirks
- `Config.gd:25` - DEBUG_MODE is `true`; loads DebugConfig.gd at runtime
- `Config.gd:28` - DebugConfig is a preload, not a runtime load
- Images loaded from `res://assets/sprites/images/`
- Save file at `user://save_game.dat`

## Testing
- `tests/test.gd` - Unit tests via Godot test framework
- Run via Editor: Debug > Run Tests