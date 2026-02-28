extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var player_speed: float = 300
@export var push_force: float = 1600
@export var dash_distance: float = 200
@export var dash_speed: float = 900
@export var dash_cooldown: float = 0.5
var _time_since_last_dash: float = dash_cooldown
var _is_dashing: float = false
var _dash_start: Vector2
var _last_input_direction: Vector2

var _last_x_right: bool;
var _last_y_down: bool;

static var player: Player;

func _enter_tree() -> void:
	player = self;

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_dir * player_speed

func play_animation(animation_name: String) -> void:
	animated_sprite_2d.flip_h = not _last_x_right;
	
	var animation_direction: String = "forward" if _last_y_down else "backward";
	animated_sprite_2d.play(animation_name + "_" + animation_direction)

func _physics_process(delta):
	get_input()
	_time_since_last_dash += delta
	var speed = velocity.length()
	
	if _time_since_last_dash > dash_cooldown and Input.is_action_just_pressed("Dash"):
		_dash_start = position
		_is_dashing = true
	
	if _is_dashing:
		move_and_collide(_last_input_direction * dash_speed * delta)
		if (position - _dash_start).length() > dash_distance or get_slide_collision_count() > 0:
			_is_dashing = false
		_time_since_last_dash = 0
		play_animation("roll");
		print("ROLL")
		return;
	
	if speed > 0:
		_last_input_direction = velocity.normalized()
		if _last_input_direction.x > 0:
			_last_x_right = true;
		elif _last_input_direction.x < 0:
			_last_x_right = false;
		if _last_input_direction.y > 0:
			_last_y_down = true;
		elif _last_input_direction.y < 0:
			_last_y_down = false;
		play_animation("run");
		print("HI")
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is RigidBody2D:
				var push_direction := -collision.get_normal()
				collider.apply_central_force(push_direction * push_force)
		return;
	
	play_animation("idle");
	
