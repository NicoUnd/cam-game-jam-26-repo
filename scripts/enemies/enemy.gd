extends RigidBody2D
class_name Enemy

var collision_shape_2d: CollisionShape2D;
static var player : Player 
@export var speed : float = 100
@export var damage : int = 5
@export var attack_cooldown : float = 1.0
@export var player_attack_grace : float = 0.2
@export var petrification_duration: float = 1
var _is_petrified : bool = false
var objects_in_range : Array[Destructable] = []
var _time_since_last_attack : float = 0.0
var _player_in_range : bool = false
var _time_since_player_in_range : float = 0

var _last_spotted: float = INF;
var _been_idle_for: float = 0;
var _been_sleeping_for: float = 0;

@export var sight_distance: float = 300;

@export var chase_for: float = 3;
@export var idle_until_sleep: float = 5;

@export var min_sleep_time: float = 0;

@export var default_state: ENEMY_STATE = ENEMY_STATE.IDLE;

@onready var animated_sprite_2d: AnimatedSprite2D = $Flippable/AnimatedSprite2D

@onready var spotted: Spotted = $Spotted

@onready var flippable: Node2D = $Flippable

enum ENEMY_STATE {IDLE, SLEEPING, CHASING, PETRIFIED};
var state: ENEMY_STATE = ENEMY_STATE.SLEEPING;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.player
	animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	state = default_state;

func petrify() -> void:
	if state == ENEMY_STATE.PETRIFIED:
		return
	linear_velocity = Vector2.ZERO;
	state = ENEMY_STATE.PETRIFIED;
	animated_sprite_2d.stop()
	var tween = create_tween()
	#tween.tween_property(animated_sprite_2d.material, "shader_parameter/progress", 1.0, petrification_duration)
	
	var current_progress = animated_sprite_2d.get_instance_shader_parameter("progress")
	if current_progress == null:
		current_progress = 0.0
	tween.tween_method(
		func(val: float): animated_sprite_2d.set_instance_shader_parameter("progress", val),
		current_progress,
		1.0,
		petrification_duration
	)

func spotted_player() -> void:
	state = ENEMY_STATE.CHASING;
	_last_spotted = 0;

func sleep() -> void:
	state = ENEMY_STATE.SLEEPING;
	_been_sleeping_for = 0;
	linear_velocity = Vector2.ZERO;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		ENEMY_STATE.PETRIFIED:
			return;
		ENEMY_STATE.IDLE:
			_been_idle_for += delta;
		ENEMY_STATE.SLEEPING:
			_been_sleeping_for += delta;
	
	move(delta)
	attack(delta)
	flippable.scale.x = -1 if linear_velocity.x < 0 else 1;
	
	if state == ENEMY_STATE.IDLE and _been_idle_for > idle_until_sleep:
		sleep();
	
	var state_space = get_world_2d().direct_space_state
	var collision_mask: int = 8 if collision_layer == 2 else 16;
	var query = PhysicsRayQueryParameters2D.create(global_position, Player.player.position, collision_mask)
	#query.exclude = enemies_and_player
	var result = state_space.intersect_ray(query)
	if result.is_empty() and player.position.distance_to(position) < sight_distance:
		if not (state == ENEMY_STATE.SLEEPING and _been_sleeping_for < min_sleep_time):
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
