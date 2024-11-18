extends Node
@onready var game_menu: Control = $".."

func unpause():
	game_menu.hide()
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and get_tree().paused == true:
		get_viewport().set_input_as_handled()
		unpause()
