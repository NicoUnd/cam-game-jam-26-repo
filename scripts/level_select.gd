extends Control

func start_level(level : int) -> void:
	print("res://scenes/levels/level_" + str(level) + ".tscn")
	get_tree().change_scene_to_file("res://scenes/levels/cave_level.tscn")
	
