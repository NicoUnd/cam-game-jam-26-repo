extends Control

class_name LevelSelect

static var max_level_complete = 0

static var current_level = 0

func get_all_buttons() -> Array:
	# Using the node path from the root of the scene
	return $MarginContainer/ScrollContainer/VBoxContainer.get_children()

func _ready():
	var buttons = get_all_buttons()
	var unlocked_level = min(buttons.size() - 1, max_level_complete + 1)
	for i in range(unlocked_level):
		var button = buttons[i]
		print(button.name)
		if button is PetrifiableButton:
			button.unlock()
			button.interacted.connect(start_level.bind(i + 1))
		

func start_level(level : int) -> void:
	print("res://scenes/levels/level_" + str(level) + ".tscn")
	current_level = level
	get_tree().change_scene_to_file("res://scenes/levels/cave_level.tscn")
	
