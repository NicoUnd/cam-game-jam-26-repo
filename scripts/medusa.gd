extends Node2D

@onready var player : Player = $".."
@export var vision_cone_angle : float = PI / 6

func petrify(looking_dir : Vector2):
	var state_space = get_world_2d().direct_space_state
	var enemies : Array[Node] = get_tree().current_scene.get_tree().get_nodes_in_group("Enemies")
	var enemies_and_player: Array[RID] = [self, player]
	
	for enemy : Node in enemies:
		if enemy is Enemy:
			enemies_and_player.append(enemy.get_rid())
	
	for enemy : Node in enemies:
		if enemy is Enemy:
			var enemy_position : Vector2 = enemy.global_position
			var enemy_direction : Vector2 = enemy_position - global_position
			var angle_to_enemy = abs(enemy_direction.angle_to(looking_dir))
			if angle_to_enemy < vision_cone_angle:
				var query = PhysicsRayQueryParameters2D.create(global_position, enemy_position)
				query.exclude = enemies_and_player
				var result = state_space.intersect_ray(query)
				if result.is_empty():
					enemy.petrify()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Petrify"):
		petrify(Vector2.RIGHT)
