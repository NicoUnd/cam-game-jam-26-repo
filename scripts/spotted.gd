extends AnimatedSprite2D
class_name Spotted

func spotted() -> void:
	visible = true;
	play("default");

func _on_animation_finished() -> void:
	visible = false;
