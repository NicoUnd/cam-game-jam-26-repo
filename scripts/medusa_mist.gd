extends Sprite2D
class_name MedusaMist

const SPEED = 300;

var direction: Vector2 = Vector2.ZERO;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * delta * SPEED;
	rotation += delta;
