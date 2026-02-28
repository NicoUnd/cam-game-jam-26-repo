extends RigidBody2D
class_name Enemy

var collision_shape_2d: CollisionShape2D;
static var player : Player 
@export var speed : float = 100
@export var damage : int = 5
@export var attack_cooldown : float = 1.0
@export var player_attack_grace : float = 0.2
var _is_petrified : bool = false
var objects_in_range : Array[Destructable] = []
var _time_since_last_attack : float = 0.0
var _player_in_range : bool = false
var _time_since_player_in_range : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.player

func petrify() -> void:
	_is_petrified = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_petrified:
		var direction = global_position.direction_to(player.global_position)
		var distance = global_position.distance_to(player.global_position)
		linear_velocity = direction * speed
		attack(delta)
		
		

func attack(delta : float) -> void:
	if _player_in_range and _time_since_player_in_range <= player_attack_grace:
		_time_since_player_in_range += delta
	if _time_since_last_attack > attack_cooldown:
		if _player_in_range: 
			if _time_since_player_in_range > player_attack_grace:
				get_tree().quit()
		for object : Destructable in objects_in_range:
			object.take_damage(damage)
		_time_since_last_attack = 0
	else:
		_time_since_last_attack += delta

func _on_hurtbox_entered(body: Node2D) -> void:
	if body is Destructable:
		objects_in_range.append(body)
	elif body is Player:
		_player_in_range = true
		_time_since_player_in_range = 0


func _on_hurtbox_exited(body: Node2D) -> void:
	if body is Destructable:
		objects_in_range.erase(body)
	elif body is Player:
		_player_in_range = false
