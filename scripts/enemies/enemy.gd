extends Node2D
class_name Enemy

var collision_shape_2d: CollisionShape2D;
static var player : Player 
@export var speed : float = 100
var _is_petrified : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.player

func petrify() -> void:
	_is_petrified = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_petrified:
		position = position.move_toward(player.global_position, speed * delta)
