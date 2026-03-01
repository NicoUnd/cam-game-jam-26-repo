extends Area2D

@export var _speed_multiplier: float = 0.5

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.player_speed *= _speed_multiplier
	elif body is Enemy:
		body.speed *= _speed_multiplier
		body.velocity *= 0.2;

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.player_speed /= _speed_multiplier
	elif body is Enemy:
		body.speed /= _speed_multiplier
