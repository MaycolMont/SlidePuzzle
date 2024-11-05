extends Node

#region PATHS

const IMAGES_PATH : String = "res://assets/sprites/images/"
const IMAGE_GROUP_PATH : String = "res://UI/images_group.tres"
const GAME_SCENE_PATH : String = "res://scenes/game.tscn"
const DEBUG_FILE_PATH : String = "res://config/DebugConfig.gd"

#endregion


#region Settings

#Audio Settings

const MUSIC_VOLUME: int = 60
const VFX_VOLUME: int = 90

#endregion


#region Debug Settings

const DEBUG_MODE = true

# Carga el archivo de depuración solo si DEBUG_MODE está activado
var DebugConfig = preload(DEBUG_FILE_PATH) if DEBUG_MODE else null

#endregion


#region Save/Load Settings

const SAVE_FILE_PATH: String = "user://save_game.dat"
const AUTO_SAVE_INTERNAL: int = 300

#endregion
