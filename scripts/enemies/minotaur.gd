extends Enemy
class_name Mintoaur

var _is_charging: bool = false;
const ACCELERATION_MAGNITUDE: float = 500;

var last_linear_velocity: Vector2;

# Called when the node enters the scene tree for the first time.
func move(delta: float) -> void:
	match state:
		ENEMY_STATE.CHASING:
			var direction = global_position.direction_to(player.global_position)
			linear_velocity += direction * ACCELERATION_MAGNITUDE * delta
			print("MINOTAUR LINEAR VELOCITY: " + str(linear_velocity))

func _physics_process(delta: float) -> void:
	super._physics_process(delta);
	match state:
		ENEMY_STATE.PETRIFIED:
			return;
	
	if linear_velocity.distance_to(last_linear_velocity) > 250:
		sleep();
	
	last_linear_velocity = linear_velocity;

func _ready() -> void:
	contact_monitor = true;
	max_contacts_reported = 1;
	super._ready();
