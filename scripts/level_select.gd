extends Control

@export var level_music : AudioStream

func get_all_buttons() -> Array:
	# Using the node path from the root of the scene
	return $MarginContainer/ScrollContainer/VBoxContainer.get_children()

func _ready():
	var buttons = get_all_buttons()
	var unlocked_level = min(buttons.size() - 1, LevelManager.max_level_index + 1)
	for i in range(unlocked_level):
		var button = buttons[i]
		if button is PetrifiableButton:
			button.interacted.connect(start_level.bind(i + 1))
			
	for i in range(unlocked_level, buttons.size()):
		var button = buttons[i]
		if button is PetrifiableButton:
			button.lock()
		

func start_level(level : int) -> void:
	print("res://scenes/levels/level_" + str(level) + ".tscn")
	LevelManager.current_level_index = level
	if level > 1:
		AudioManager.play_music(level_music)
	AudioManager.music_volume(50)
	get_tree().change_scene_to_file("res://scenes/levels/level_" + str(level) + ".tscn")
	
