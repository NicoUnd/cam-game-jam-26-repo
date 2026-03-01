extends Area2D

@export var _speed_multiplier: float = 0.4;

var minotaurs: Array[Mintoaur] = [];

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.player_speed *= _speed_multiplier
	elif body is Enemy:
		body.speed *= _speed_multiplier
		if body is Mintoaur:
			minotaurs.append(body);
			body.in_puddle = true;

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.player_speed /= _speed_multiplier
	elif body is Enemy:
		body.speed /= _speed_multiplier
		if body is Mintoaur:
			body.in_puddle = false;
			minotaurs.erase(body);
