extends Control

# Exposing private variables to the Inspector for strict encapsulation
@export var _fade_duration: float = 0.8

@onready var _nine_patch: NinePatchRect = $NinePatchRect
@onready var _interaction_button: TextureButton = $TextureButton

func _ready() -> void:
	# Ensure this button instance has its own unique material
	_nine_patch.material = _nine_patch.material.duplicate()
	
	# Update resolution on startup, and connect to the resize signal
	_update_shader_resolution()
	_nine_patch.resized.connect(_update_shader_resolution)
	
	_interaction_button.mouse_entered.connect(_on_mouse_entered)
	_interaction_button.mouse_exited.connect(_on_mouse_exited)

func _update_shader_resolution() -> void:
	# Pass the actual screen size of the 9-patch directly to the shader
	#_nine_patch.material.set_shader_parameter("pixel_resolution", _nine_patch.size)
	pass

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(_nine_patch.material, "shader_parameter/progress", 1, _fade_duration)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(_nine_patch.material, "shader_parameter/progress", 0.0, _fade_duration)
