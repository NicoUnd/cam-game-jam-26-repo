extends Node2D

const SNAKE_SCENE = preload("uid://c8oau2rn4hi80")

var time_elapsed: float = 0;
var phase: int = 0;

@onready var y_sort: Node2D = $"Y-Sort"

@onready var player: Player = $"Y-Sort/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.in_tutorial = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta;
	
	match phase:
		0:
			if time_elapsed > 10:
				var new_snake: Enemy = SNAKE_SCENE.instantiate();
				y_sort.add_child(new_snake);
				new_snake.position = Vector2(300, 50);
				phase += 1;
