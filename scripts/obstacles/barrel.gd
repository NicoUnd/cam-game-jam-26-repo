extends Obstacle
class_name Barrel

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func destroy() -> void:
	collision_shape_2d.disabled = true;
	animated_sprite_2d.play("default");
