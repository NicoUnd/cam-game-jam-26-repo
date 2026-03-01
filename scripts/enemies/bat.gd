extends Enemy
class_name Bat

func move(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * speed
			move_and_slide();


func _on_timer_timeout() -> void:
	if player.state == Player.PLAYER_STATE.DYING:
		return;
	match state:
		ENEMY_STATE.IDLE:
			velocity = Vector2.RIGHT.rotated(randf_range(0, 2*PI)) * speed/2
