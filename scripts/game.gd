extends CanvasLayer
## Main game controller. Spawns the board, manages time, pause menu, and win flow.

## Preview thumbnail of the current puzzle image.
@export var texture_preview: TextureRect
## Preloaded [Board] scene to instantiate.
@export var board_scene: PackedScene
## Reference to the [TimeLabel] node for elapsed time display.
@export var time_label: TimeLabel
## Container where the [Board] will be added.
@export var board_container: PanelContainer

func _ready() -> void:
	for node: Node in get_tree().get_nodes_in_group("popup"):
		node.hide()
	_verify_data()
	_set_board()
	_set_image_preview()
	time_label.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		$ConfirmPopup.show()
		get_tree().paused = true

#region private methods
## Loads saved data on first launch.
func _verify_new_game() -> void:
	if Global.new_game:
		Global.load_data()
		Global.new_game = false

## Sets the preview thumbnail to the selected puzzle image.
func _set_image_preview() -> void:
	texture_preview.texture = Global.texture_resource

## Instantiates a [Board] with the selected image and grid size.
func _set_board() -> void:
	var board: Board = board_scene.instantiate()
	board.size = 220
	board.texture = Global.texture_resource
	board.pieces_range = Global.grid_size
	board.solved.connect(_on_board_solved)
	board_container.add_child(board)

## Ensures texture data exists; falls back to debug default if missing.
func _verify_data() -> void:
	if not Global.texture_resource:
		Global._simulate_test_data()
#endregion

## Returns to the main menu scene.
func _go_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(Config.MENU_SCENE_PATH)

## Called when the board is solved. Saves the time and shows the win popup.
func _on_board_solved(number_of_movements: int) -> void:
	Global.save_time(time_label.get_time())
	get_tree().paused = true
	%TimeLabel.text += time_label.time_text
	%MovementsLabel.text += str(number_of_movements)
	$WinPopup.show()
