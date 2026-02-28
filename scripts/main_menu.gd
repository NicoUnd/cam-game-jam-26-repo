extends Control

func start_game():
	get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")
	
func quit_game():
	get_tree().quit()
