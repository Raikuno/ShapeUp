extends Node


var enemy : PackedScene

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

	

func _on_mob_spawn_timer_timeout():
	#1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	var enemyRandom = randi_range(1,4)
	match enemyRandom:
		1:
			enemy = load("res://Scenes/Enemies/enemyCylinder.tscn")
		2:
			enemy = load("res://Scenes/Enemies/enemyCube.tscn")
		3:
			enemy = load("res://Scenes/Enemies/enemySphere.tscn")
		4:
			enemy = load("res://Scenes/Enemies/enemyPyramid.tscn")
	var enemyObject = enemy.instantiate()
	
	var enemySpawnLocation = get_node("player/Path3D/PathFollow3D")
	enemySpawnLocation.progress_ratio = randf()
	print(enemySpawnLocation.position.x)
	enemyObject.initialize(enemySpawnLocation.position + $player.position, $player.position)
	add_child(enemyObject)
