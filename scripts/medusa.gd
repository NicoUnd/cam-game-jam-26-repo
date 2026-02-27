extends Node2D

func petrify():
	var state_space = get_world_2d().direct_space_state
	var enemies : Array[Node] = get_tree().current_scene.get_tree().get_nodes_in_group("Enemies")
	for enemy : Node in enemies:
		if enemy is Enemy:
			var query = PhysicsRayQueryParameters2D.create(position, enemy.position)
			var result = state_space.intersect_ray(query)
			print(result)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Petrify"):
		petrify()
