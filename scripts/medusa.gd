extends Node2D

@onready var player : Player = $".."
@export var vision_cone_angle : float = PI / 3

var switch_to_level_select = func(): get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")

func petrify(looking_dir : Vector2):
	var state_space = get_world_2d().direct_space_state
	var enemies : Array[Node] = get_tree().current_scene.get_tree().get_nodes_in_group("Enemies")
	#var enemies_and_player: Array[RID] = [self, player]
	
	#for enemy : Node in enemies:
	#	if enemy is Enemy:
	#		enemies_and_player.append(enemy.get_rid())
	var non_petrified_enemies : Array[Enemy]= []
	var petrified_enemies : Array[Enemy] = []
	for enemy : Node in enemies:
		if enemy is Enemy:
			var enemy_position : Vector2 = enemy.global_position
			var enemy_direction : Vector2 = enemy_position - global_position
			var angle_to_enemy = abs(enemy_direction.angle_to(looking_dir))
			if angle_to_enemy < vision_cone_angle/2:
				var query = PhysicsRayQueryParameters2D.create(global_position, enemy_position, 8 + 16)
				#query.exclude = enemies_and_player
				var result = state_space.intersect_ray(query)
				if result.is_empty():
					enemy.petrify()
					petrified_enemies.append(enemy)
					continue
			non_petrified_enemies.append(enemy)
	
	if (non_petrified_enemies.size() > 0):
		for enemy in non_petrified_enemies:
			enemy.z_index = 30
		FadeToBlack.fade_to_black.fade_in(get_tree().reload_current_scene, "You failed to petrify all the enemies")
	else:
		for enemy in petrified_enemies:
			enemy.z_index = 30
			LevelManager.max_level_complete = max(LevelManager.max_level_index, LevelManager.current_level)
		FadeToBlack.fade_to_black.fade_in(switch_to_level_select, "You Win")
