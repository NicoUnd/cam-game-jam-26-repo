extends RigidBody2D
class_name Enemy

var collision_shape_2d: CollisionShape2D;
static var player : Player 
@export var speed : float = 100
@export var damage : int = 5
@export var attack_cooldown : float = 1.0
@export var player_attack_grace : float = 0.2
var objects_in_range : Array[Destructable] = []
var _time_since_last_attack : float = 0.0
var _player_in_range : bool = false
var _time_since_player_in_range : float = 0

var _last_spotted: float = INF;
var _been_idle_for: float = 0;

@export var chase_for: float = 3;
@export var idle_until_sleep: float = 5;

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var spotted: Spotted = $Spotted

enum ENEMY_STATE {IDLE, SLEEPING, CHASING, PETRIFIED};
var state: ENEMY_STATE = ENEMY_STATE.SLEEPING;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.player

func petrify() -> void:
	state = ENEMY_STATE.PETRIFIED;

func spotted_player() -> void:
	state = ENEMY_STATE.CHASING;
	_last_spotted = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		ENEMY_STATE.PETRIFIED:
			return;
		ENEMY_STATE.IDLE:
			_been_idle_for += delta;
	
	move(delta)
	attack(delta)
	animated_sprite_2d.flip_h = linear_velocity.x < 0;
	
	if state == ENEMY_STATE.IDLE and _been_idle_for > idle_until_sleep:
		state = ENEMY_STATE.SLEEPING;
	
	var state_space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, Player.player.position, 4)
	#query.exclude = enemies_and_player
	var result = state_space.intersect_ray(query)
	if result.is_empty():
		spotted_player();
	else:
		_last_spotted += delta;
		if state == ENEMY_STATE.CHASING and _last_spotted > chase_for:
			state = ENEMY_STATE.IDLE;
			_been_idle_for = 0;

func _process(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			animated_sprite_2d.play("run")
			spotted.spotted();
		ENEMY_STATE.IDLE:
			animated_sprite_2d.play("idle")
		ENEMY_STATE.SLEEPING:
			animated_sprite_2d.play("sleep")

func move(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			var direction = global_position.direction_to(player.global_position)
			linear_velocity = direction * speed

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
