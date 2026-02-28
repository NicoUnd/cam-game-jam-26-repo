extends Control

class_name PetrifiableButton

@export var petrification_duration: float = 0.6
@export var label_text : String = ""
@export var locked : bool = false
@export var button_press_sound : AudioStream

signal interacted

@onready var _canvas_group: CanvasGroup = $CanvasGroup
@onready var _interaction_button: TextureButton = $TextureButton

func _ready() -> void:
	$CanvasGroup/NinePatchRect/Label.text = label_text
	
	_canvas_group.material = _canvas_group.material.duplicate()
	if not locked:
		unlock()
	else:
		_canvas_group.material.set_shader_parameter("progress", 1.0)

func lock() -> void:
	locked = true
	if _interaction_button.pressed.is_connected(_on_button_pressed):
		_interaction_button.pressed.disconnect(_on_button_pressed)
	if _interaction_button.mouse_entered.is_connected(_on_mouse_entered):
		_interaction_button.mouse_entered.disconnect(_on_mouse_entered)
	if _interaction_button.mouse_exited.is_connected(_on_mouse_exited):
		_interaction_button.mouse_exited.disconnect(_on_mouse_exited)
	
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 1.0, petrification_duration)

func unlock() -> void:
	locked = false
	_interaction_button.pressed.connect(_on_button_pressed)
	_interaction_button.mouse_entered.connect(_on_mouse_entered)
	_interaction_button.mouse_exited.connect(_on_mouse_exited)
	
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 0.0, petrification_duration)
	
func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 1.0, petrification_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(_canvas_group.material, "shader_parameter/progress", 0.0, petrification_duration)


func _on_button_pressed() -> void:
	AudioManager.play_sfx(button_press_sound)
	interacted.emit()
