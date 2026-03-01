extends Node
var current_level_index: int = 0
var max_level_index: int = 10

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape") and current_level_index != 1:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
