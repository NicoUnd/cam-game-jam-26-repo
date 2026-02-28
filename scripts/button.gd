extends Control

@export var petrification_duration: float = 0.6

@onready var _canvas_group: CanvasGroup = $CanvasGroup
@onready var _interaction_button: TextureButton = $TextureButton
@onready var _nine_patch: NinePatchRect = $CanvasGroup/NinePatchRect

func _ready() -> void:
	# Duplicate the material on the CanvasGroup so each button is independent
	_canvas_group.material = _canvas_group.material.duplicate()
	
	_interaction_button.mouse_entered.connect(_on_mouse_entered)
	_interaction_button.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 1.0, petrification_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 0.0, petrification_duration)
