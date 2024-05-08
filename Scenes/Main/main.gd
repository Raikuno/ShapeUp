extends Node

var timeSecond = 0
var timeMinute = 0
var enemy : PackedScene
const MENU = "res://Scenes/Main/mainPPK.tscn"

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Menu.show()

		

func _ready():
	$Menu.hide()

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
	enemyObject.initialize(enemySpawnLocation.position + $player.position, $player.position, enemyRandom)
	add_child(enemyObject)


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU)
	


func _on_start_pressed():
	$Menu.hide()
	get_tree().paused = false


func _on_timer_timeout():
	timeSecond += 1
	if timeSecond == 60:
		timeSecond = 0
		timeMinute += 1
	if timeSecond < 10 && timeMinute < 10: # Perdón, me dió flojera
		$Time/Label.text =  "0%s:0%s" %  [timeMinute ,timeSecond]
	elif timeSecond < 10:
		$Time/Label.text =  "%s:0%s" %  [timeMinute ,timeSecond]
	elif timeMinute < 10:
		$Time/Label.text =  "0%s:%s" %  [timeMinute ,timeSecond]
	else:
		$Time/Label.text =  "%s:%s" %  [timeMinute ,timeSecond]

