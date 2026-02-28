extends Node2D

const SNAKE_SCENE = preload("uid://c8oau2rn4hi80")

var time_elapsed: float = 0;
var phase: int = 0;

@onready var y_sort: Node2D = $"Y-Sort"

@onready var player: Player = $"Y-Sort/Player"

@onready var v_wall: Obstacle = $"Y-Sort/VWall"
@onready var v_wall_2: Obstacle = $"Y-Sort/VWall2"
@onready var v_wall_3: Obstacle = $"Y-Sort/VWall3"
@onready var v_wall_4: Obstacle = $"Y-Sort/VWall4"
@onready var v_wall_bottom: Obstacle = $"Y-Sort/VWallBottom"
@onready var v_wall_top: Obstacle = $"Y-Sort/VWallTop"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.in_tutorial = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta;
	
	match phase:
		0:
			if time_elapsed > 15:
				var new_snake: Enemy = SNAKE_SCENE.instantiate();
				y_sort.add_child(new_snake);
				new_snake.position = Vector2(300, 50);
				phase += 1;
		1:
			if time_elapsed > 45:
				v_wall.queue_free();
				v_wall_2.queue_free();
				v_wall_3.queue_free();
				v_wall_4.queue_free();
				v_wall_top.queue_free();
				v_wall_bottom.queue_free();
				phase += 1;
