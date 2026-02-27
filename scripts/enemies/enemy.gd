extends Node2D
class_name Enemy

var collision_shape_2d: CollisionShape2D;
static var player : Player = Player.player
@export var speed : float = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func petrify() -> void:
	print("dead")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = position.move_toward(player.global_position, speed * delta)
