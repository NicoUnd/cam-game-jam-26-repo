extends Enemy
class_name Mintoaur

var _is_charging: bool = false;
const ACCELERATION_MAGNITUDE: float = 300;

var last_velocity: Vector2;

var in_puddle: bool = false;

# Called when the node enters the scene tree for the first time.
func move(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			var direction = global_position.direction_to(player.global_position)
			velocity += direction * ACCELERATION_MAGNITUDE * delta
			move_and_slide()

func barrel_check() -> void:
	var barrels: Array[Node] = get_tree().get_nodes_in_group("Barrels")
	for barrel in barrels:
		if not barrel.destroyed and barrel.position.distance_to(position) < 65:
			barrel.destroy();
			return;

func _physics_process(delta: float) -> void:
	super._physics_process(delta);
	match state:
		ENEMY_STATE.PETRIFIED:
			return;
	
	if in_puddle:
		velocity = velocity.normalized() * 50;
	
	if velocity.distance_to(last_velocity) > 300 and not in_puddle:
		barrel_check();
		sleep();
	
	last_velocity = velocity;
