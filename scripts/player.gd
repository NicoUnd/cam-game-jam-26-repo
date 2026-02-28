extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var medusa: Node2D = $Medusa

@export var player_speed: float = 300
@export var push_force: float = 1600
@export var dash_distance: float = 200
@export var dash_speed: float = 900
@export var dash_cooldown: float = 0.5

@export var footstep_sounds: AudioStream;

var _time_since_last_dash: float = dash_cooldown
var _is_dashing: float = false
#var _dash_start: Vector2
var _last_input_direction: Vector2

var _last_x_right: bool;
var _last_y_down: bool;


@onready var frames: SpriteFrames = animated_sprite_2d.sprite_frames

static var player: Player;

func _enter_tree() -> void:
	player = self;

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_dir * player_speed

func play_animation(animation_name: String, duration : float = -1) -> void:
	animated_sprite_2d.flip_h = not _last_x_right;
	var animation_direction: String = "forward" if _last_y_down else "backward";
	animation_name += "_" + animation_direction
	if frames.has_animation(animation_name):
		var anim_speed_multiplier: float = 1
		if duration != -1:
			var frame_count : int = frames.get_frame_count(animation_name)
			var fps: float = frames.get_animation_speed(animation_name)
			var base_duration: float = frame_count / fps
			anim_speed_multiplier = base_duration / duration
		print(anim_speed_multiplier)
		animated_sprite_2d.play(animation_name, anim_speed_multiplier)

func _physics_process(delta):
	get_input()
	_time_since_last_dash += delta
	var speed = velocity.length()
	
	if _time_since_last_dash > dash_cooldown and Input.is_action_just_pressed("Dash"):
		#_dash_start = position
		_is_dashing = true
	
	set_collision_mask_value(2, not _is_dashing); # don't collide with enemies when dashing
	
	if _is_dashing:
		if move_and_collide(_last_input_direction * dash_speed * delta): # collided with something
			play_animation("bump");
		else:
			play_animation("roll", dash_distance/dash_speed);
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
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is RigidBody2D:
				var push_direction := -collision.get_normal()
				collider.apply_central_force(push_direction * push_force)
		return;
	
	play_animation("idle");
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Petrify"):
		medusa.petrify(_last_input_direction);

func _on_animated_sprite_2d_animation_finished() -> void:
	if _is_dashing:
		_time_since_last_dash = 0;
		_is_dashing = false;
