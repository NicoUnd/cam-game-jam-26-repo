extends Control

@export var petrification_duration: float = 0.6
@export var label_text : String = ""
@export var locked : bool = false

signal interacted

@onready var _canvas_group: CanvasGroup = $CanvasGroup
@onready var _interaction_button: TextureButton = $TextureButton

func _ready() -> void:
	$CanvasGroup/NinePatchRect/Label.text = label_text
	
	_canvas_group.material = _canvas_group.material.duplicate()
	if not locked:
		unlock()
	#else:
		#_canvas_group.set_instance_shader_parameter("progress", 1.0)

func unlock() -> void:
	_interaction_button.pressed.connect(_on_button_pressed)
	_interaction_button.mouse_entered.connect(_on_mouse_entered)
	_interaction_button.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 1.0, petrification_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 0.0, petrification_duration)


func _on_button_pressed() -> void:
	interacted.emit()
