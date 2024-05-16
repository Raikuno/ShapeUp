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

#1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide


func spawnMob(enemyRandom,amount, statsMultiplier):
	for i in amount + timeMinute:
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
		enemyObject.initialize(enemySpawnLocation.position + $player.position, $player.position, enemyRandom, statsMultiplier + timeMinute)
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
		$Time/Time.text =  "0%s:0%s" %  [timeMinute ,timeSecond]
	elif timeSecond < 10:
		$Time/Time.text =  "%s:0%s" %  [timeMinute ,timeSecond]
	elif timeMinute < 10:
		$Time/Time.text =  "0%s:%s" %  [timeMinute ,timeSecond]
	else:
		$Time/Time.text =  "%s:%s" %  [timeMinute ,timeSecond]




func _on_try_yourself_timeout():
	spawnMob(4,1,-1.8)
