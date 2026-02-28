extends Area2D

@export var _speed_multiplier: float = 0.5

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.player_speed *= _speed_multiplier
	elif body is Enemy:
		body.speed *= _speed_multiplier

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.player_speed /= _speed_multiplier
	elif body is Enemy:
		body.speed /= _speed_multiplier
