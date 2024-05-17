extends Node

var timeSecond = 0
var timeMinute = 0
var enemy : PackedScene


func _ready():
	$Menu.hide()
	$player.initializePlayerTutorial()
#1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide


func spawnMob(enemyRandom,amount, statsMultiplier):

		enemy = load("res://Scenes/Tutorial/tutorial_enemy.tscn")
		var enemyObject = enemy.instantiate()
		enemyObject.initialize(Vector3(0,0,25) + $player.position, $player.position, enemyRandom, statsMultiplier)
		add_child(enemyObject)



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
	spawnMob(2,1,0)
