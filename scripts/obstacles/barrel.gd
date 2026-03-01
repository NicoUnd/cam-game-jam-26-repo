extends Obstacle
class_name Barrel

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var destroyed: bool = false;

func destroy() -> void:
	destroyed = true;
	collision_shape_2d.disabled = true;
	animated_sprite_2d.play("default");
