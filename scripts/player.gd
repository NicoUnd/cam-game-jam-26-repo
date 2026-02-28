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

@onready var hurtbox_area_2d: Area2D = $HurtboxArea2D

var _time_since_last_dash: float = dash_cooldown
#var _dash_start: Vector2
var _last_input_direction: Vector2 = Vector2.RIGHT;

var _last_x_right: bool;
var _last_y_down: bool;

enum PLAYER_STATE {DEFAULT, DASHING, BUMPING, DYING}
var state: PLAYER_STATE = PLAYER_STATE.DEFAULT;

@onready var frames: SpriteFrames = animated_sprite_2d.sprite_frames

static var player: Player;

func _enter_tree() -> void:
	player = self;

func get_input_dir() -> Vector2:
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	return input_dir;

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
		#print(anim_speed_multiplier)
		animated_sprite_2d.play(animation_name, anim_speed_multiplier)

func _physics_process(delta):
	if state == PLAYER_STATE.DYING:
		return;
	
	_time_since_last_dash += delta
	
	if _time_since_last_dash > dash_cooldown and Input.is_action_just_pressed("Dash"):
		#_dash_start = position
		state = PLAYER_STATE.DASHING;
	
	set_collision_mask_value(2, state != PLAYER_STATE.DASHING); # don't collide with enemies when dashing
	hurtbox_area_2d.monitorable = state != PLAYER_STATE.DASHING;
	
	match state:
		PLAYER_STATE.BUMPING:
			return;
		PLAYER_STATE.DASHING:
			var kinematic_collision: KinematicCollision2D = move_and_collide(_last_input_direction * dash_speed * delta);
			if kinematic_collision: # collided with something
				play_animation("bump");
				velocity = Vector2.ZERO;
				var collider: Object = kinematic_collision.get_collider();
				if collider is Barrel:
					collider.destroy();
				state = PLAYER_STATE.BUMPING;
			else:
				play_animation("roll", dash_distance/dash_speed);
			return;
	
	velocity = get_input_dir() * player_speed;
	var speed = velocity.length()
	
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

func die() -> void:
	animated_sprite_2d.play("die");
	print("DIE")
	state = PLAYER_STATE.DYING;
	set_collision_layer_value(8 + 16, true);

func _process(delta: float) -> void:
	if state == PLAYER_STATE.DYING:
		return;
	if Input.is_action_just_pressed("Petrify"):
		medusa.petrify(_last_input_direction);

func _on_animated_sprite_2d_animation_finished() -> void:
	if state in [PLAYER_STATE.DASHING, PLAYER_STATE.BUMPING]:
		_time_since_last_dash = 0;
		state = PLAYER_STATE.DEFAULT;
	elif state == PLAYER_STATE.DYING:
		get_tree().reload_current_scene();
