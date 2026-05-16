extends Node
## Central constants and debug configuration for the project.

#region PATHS
## Directory containing source image files for the puzzle.
const IMAGES_PATH: String = "res://assets/sprites/images/"
## Resource file defining the ButtonGroup for image selection.
const IMAGE_GROUP_PATH: String = "res://UI/images_group.tres"
## Main gameplay scene.
const GAME_SCENE_PATH: String = "res://scenes/game.tscn"
## Main menu scene.
const MENU_SCENE_PATH: String = "res://scenes/main.tscn"
## Debug configuration script (loaded only when [member DEBUG_MODE] is true).
const DEBUG_FILE_PATH: String = "res://config/DebugConfig.gd"
#endregion

#region Settings
## Background music volume (0-100).
const MUSIC_VOLUME: int = 60
## Sound effects volume (0-100).
const VFX_VOLUME: int = 90
#endregion

#region Debug Settings
## When true, loads [DebugConfig] and skips the menu for faster iteration.
const DEBUG_MODE: bool = true

## Reference to the [DebugConfig] script, preloaded only if [member DEBUG_MODE] is true.
var DebugConfig: Variant = preload(DEBUG_FILE_PATH) if DEBUG_MODE else null
#endregion

#region Save / Load Settings
## Path for the persistent save file.
const SAVE_FILE_PATH: String = "user://save_game.dat"
## Auto-save interval in seconds (unused).
const AUTO_SAVE_INTERNAL: int = 300
#endregion
