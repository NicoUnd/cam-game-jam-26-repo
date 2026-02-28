extends Control

@export var menu_music : AudioStream

func _ready() -> void:
	AudioManager.play_music(menu_music)

func start_game():
	get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")
	
func quit_game():
	get_tree().quit()
