extends AnimatedSprite2D

@onready var enemy: Enemy = $".."

func _on_timer_timeout() -> void:
	if enemy.state == Enemy.ENEMY_STATE.SLEEPING:
		visible = true;
		play("default")

func _on_animation_finished() -> void:
	visible = false;
