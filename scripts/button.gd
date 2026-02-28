extends Control

@export var _fade_duration: float = 0.8

@onready var _nine_patch: NinePatchRect = $NinePatchRect
@onready var _interaction_button: TextureButton = $TextureButton

func _ready() -> void:
	_nine_patch.material = _nine_patch.material.duplicate()
	
	_interaction_button.mouse_entered.connect(_on_mouse_entered)
	_interaction_button.mouse_exited.connect(_on_mouse_exited)



func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(_nine_patch.material, "shader_parameter/progress", 1, _fade_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(_nine_patch.material, "shader_parameter/progress", 0.0, _fade_duration)
