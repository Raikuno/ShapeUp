extends Node
var SCOREBOARD = "res://Scenes/ScoreBoard/ScoreBoard.tscn"
var timeSecond = 0
var timeMinute = 0
var nightDarkCounter = 6
var sameEnemy = false
var enemyArmy = 4
var miniBossSpawnRate = 200
var nightMode = false
var currentDayTime = ""
var enemy : PackedScene
const MENU = "res://Scenes/Main/mainPPK.tscn"
@onready var messageLabel = $Time/Messages

var randomMessage = [
	"Los enemigos están desarrollando visión nocturna", 
	"Los enemigos están flexeando sus músculos",
	"Los enemigos se preparan para correr una maratón",
	"Los cubos están afilando sus bordes",
	"Los cubos sienten envidia de los cubos de rubik",
	"Las esferas se están puliendo",
	"Las esferas ruedan con desesperación",
	"Los cilindros cilindrean su cilindrada cilíndrica",
	"Los cilindros aprendieron a ser útiles",
	"Las peakamides se cuestionan porqué son tan buenas",
	"Las pirámides están haciendo teorías cospiranoicas",
	"Los enemigos están haciendo mewing",
	"Supercalifragilisticoespialodoso...
	los enemigos te intentan distraer...",
	"Los enemigos están farmeando para subir a nv 100",
	"Los enemigos se están poniendo MUY NERVIOSOS"]
var randomEventMessage = [
	"¡¡Se aproxima una horda!!",
	"¡¡Se aproxima un jefe!!",
	"¡¡Están dominando el server!!"]

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Menu.show()


func _ready():
	setText()
	SignalsTrain.clubPenguinIsKill.connect(endOfGame)
	$Menu.hide()
	$player.selectPart()	
	$DayCicle.play("Day")
	currentDayTime = $DayCicle.current_animation

func setText():
	$Menu/Pause.text = tr("PAUSE")
	$Menu/Start.text = tr("PAUSE_RESUME")
	$Menu/Exit.text = tr("PAUSE_BACK")

func _on_mob_spawn_timer_timeout():
	#1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	if sameEnemy:
		spawnMob(enemyArmy, 1 + timeMinute, 0, false)
	else:
		var enemyRandom = randi_range(1,4)
		if nightMode:
			spawnMob(enemyRandom, 1 + roundi(timeMinute/2), 0, false)
		else:
			spawnMob(enemyRandom, 1 + timeMinute, -0.5, false)
	
func endOfGame():
	Score.time = $Time/Time.text
	$Timer.stop()
	Score.setScore()
	changeRoom()


func spawnMob(enemyRandom,amount, statsMultiplier, bossEnemy):
	if nightMode:
		statsMultiplier += 1.5
	for i in amount:
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
		if bossEnemy:
			enemyObject.onBossSpawn()
		elif randi_range(1,miniBossSpawnRate) == 1 || nightMode:
			print("mninijefe")
			enemyObject.onMiniBossSpawn()
		add_child(enemyObject)

func _on_exit_pressed():
	get_tree().paused = false
	queue_free()
	RoomManager.changeRoom(MENU)
func changeRoom():
	RoomManager.changeRoom(SCOREBOARD)
	queue_free()
func _on_start_pressed():
	$Menu.hide()
	get_tree().paused = false

func _on_timer_timeout():
	timeSecond += 1
	if timeSecond == 15:
		$Eventos.start()
	if timeSecond == 60:
		if miniBossSpawnRate > 50:
			miniBossSpawnRate -= 10
		timeSecond = 0
		timeMinute += 1
		showMessage(0, 0, 10)
		$EventText.play("NormalTextEnter")
	if timeSecond < 10 && timeMinute < 10: # Perdón, me dió flojera
		$Time/Time.text =  "0%s:0%s" %  [timeMinute ,timeSecond]
	elif timeSecond < 10:
		$Time/Time.text =  "%s:0%s" %  [timeMinute ,timeSecond]
	elif timeMinute < 10:
		$Time/Time.text =  "0%s:%s" %  [timeMinute ,timeSecond]
	else:
		$Time/Time.text =  "%s:%s" %  [timeMinute ,timeSecond]

func showMessage(messageType, messageColor, messageTime): # 0 negro, 1 cilindro, 2 cubo, 3 esfera , 4 peakamide
	match messageColor:
		0:
			messageLabel.add_theme_color_override("font_color", Color.BLACK)
		1:
			messageLabel.add_theme_color_override("font_color", Color.GREEN) 
		2:
			messageLabel.add_theme_color_override("font_color", Color.RED) 
		3:
			messageLabel.add_theme_color_override("font_color", Color.BLUE)
		4:
			messageLabel.add_theme_color_override("font_color", Color.YELLOW)
	if messageColor != 0:
		messageLabel.text = randomEventMessage[messageType]
	else:
		messageLabel.text = randomMessage[randi_range(0,randomMessage.size() -1)]
	$Time/Messages.show()

	
func _on_eventos_timeout():
	var enemyRandom = randi_range(1,4)
	match(randi_range(0,2)):
		0: #horda
			showMessage(0, enemyRandom, 10)
			spawnMob(enemyRandom, 20 + timeMinute, 1, false)
		1: #boss
			showMessage(1, enemyRandom, 10)
			spawnMob(enemyRandom, 1 + roundi(timeMinute / 3), 4, true)
		2: #golpe de estado
			showMessage(2, enemyRandom, 40)
			sameEnemy = true
			enemyArmy = enemyRandom
			$EventCooldown.start(40)
	$EventText.play("EventTextEnter")	


func _on_event_cooldown_timeout():
	sameEnemy = false

func loopBgm():
	$AudioStreamPlayer.play()


func _on_day_cicle_animation_finished(anim_name):
	if currentDayTime == "Day":
		if randi_range(1,nightDarkCounter) == 1:
			nightDarkCounter = 10
			$Time/Noche.add_theme_color_override("font_color", Color.WEB_PURPLE)
			$Time/Noche.show()
			$NightText.play("NightTextEntrance")
			nightMode = true
			$DayCicle.play("nightDark")
		else:
			if nightDarkCounter > 2:
				nightDarkCounter -= 2
			$DayCicle.play("night")
	else:
		$Time/Noche.hide()
		nightMode = false
		$DayCicle.play("Day")
		
	currentDayTime = $DayCicle.current_animation


func hideText(anim_name):
	$Time/Messages.hide()
