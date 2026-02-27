extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 300
@export var _continuous_push_force: float = 800.0

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	if velocity.length() > 0:
		move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider is RigidBody2D:
			var push_direction := -collision.get_normal()
			
			# Apply a steady force rather than an instantaneous spike
			collider.apply_central_force(push_direction * _continuous_push_force)
