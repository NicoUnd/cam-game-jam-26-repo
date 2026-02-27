extends CharacterBody2D
class_name Player

@export var player_speed = 300
@export var push_force = 1600
@export var dash_distance = 200
@export var dash_speed = 900
@export var dash_cooldown = 0.5
var _time_since_last_dash = dash_cooldown
var _is_dashing = false
var _dash_start
var _dash_dir

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * player_speed
	
func _physics_process(delta):
	get_input()
	_time_since_last_dash += delta
	var speed = velocity.length()
	if speed > 0:
		_dash_dir = velocity.normalized()
		move_and_slide()

		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is RigidBody2D:
				var push_direction := -collision.get_normal()
				collider.apply_central_force(push_direction * push_force)

	if _time_since_last_dash > dash_cooldown and Input.is_action_just_pressed("Dash"):
		_dash_start = position
		_is_dashing = true
	
	if _is_dashing:
		move_and_collide(_dash_dir * dash_speed * delta)
		if (position - _dash_start).length() > dash_distance or get_slide_collision_count() > 0:
			_is_dashing = false
		_time_since_last_dash = 0
