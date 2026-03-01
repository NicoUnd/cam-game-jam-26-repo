extends Node2D

func _ready() -> void:
	if LevelManager.current_level_index > 1:
		AudioManager.start_music()
