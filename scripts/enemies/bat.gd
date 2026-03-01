extends Enemy
class_name Bat


func move(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			var direction = global_position.direction_to(player.global_position)
			linear_velocity = direction * speed


func _on_timer_timeout() -> void:
	if player.state == Player.PLAYER_STATE.DYING:
		return;
	match state:
		ENEMY_STATE.IDLE:
			linear_velocity = Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * speed/2
