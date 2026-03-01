extends Control

@export var menu_music : AudioStream

@onready var start_button: PetrifiableButton = $MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	AudioManager.music_volume(100)
	AudioManager.play_music(menu_music)
	print("tried to grab focus")
	start_button.grab_focus()

func start_game():
	get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")
	
func quit_game():
	get_tree().quit()
