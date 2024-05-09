extends Node

var timeSecond = 0
var timeMinute = 0
var enemy : PackedScene
const MENU = "res://Scenes/Main/mainPPK.tscn"
@onready var messageLabel = $Time/Messages

var randomMessage = [
	"Los enemigos están flexeando sus putísimos musculos 
 	joder sí como me pone que los enemigos hagan pectorales", 
	"Los enemigos están flexeando sus musculos ",
	"Los enemigos se preparan para correr una maratón",
	"Los cubos están afilando sus bordes",
	"Las esferas están puliendose",
	"Los cilindros aprendieron a no cagarse encima",
	"Las pirámides están haciendo teorías cospiranoicas",
	"Los enemigos están haciendo mewing",
	"Supercalifragilisticoespialodoso...
	los enemigos te intentan distraer...",
	"Los enemigos están farmeando para subir a nv 100",
	"Los enemigos tocan los tambores de la liberación"]
var randomEventMessage = [
	"¡¡Se aproxima una horda!!"]

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Menu.show()

		

func _ready():
	$Menu.hide()

func _on_mob_spawn_timer_timeout():
	#1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	var enemyRandom = randi_range(1,4)
	spawnMob(enemyRandom, 1, 0)


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
		showMessage(0)
		$Eventos.start()
	if timeSecond < 10 && timeMinute < 10: # Perdón, me dió flojera
		$Time/Time.text =  "0%s:0%s" %  [timeMinute ,timeSecond]
	elif timeSecond < 10:
		$Time/Time.text =  "%s:0%s" %  [timeMinute ,timeSecond]
	elif timeMinute < 10:
		$Time/Time.text =  "0%s:%s" %  [timeMinute ,timeSecond]
	else:
		$Time/Time.text =  "%s:%s" %  [timeMinute ,timeSecond]

func showMessage(messageType): # 0 negro, 1 cilindro, 2 cubo, 3 esfera , 4 peakamide
	$Time/Messages.show()
	match messageType:
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
	if messageType != 0:
		messageLabel.text = randomEventMessage[randi_range(0,randomEventMessage.size() -1)]
	else:
		messageLabel.text = randomMessage[randi_range(0,randomMessage.size() -1)]
	
	$MessageTime.start()
	Label
func _on_eventos_timeout():
	var enemyRandom = randi_range(1,4)
	showMessage(enemyRandom)
	spawnMob(enemyRandom, 10, 1)


func _on_message_time_timeout():
	$Time/Messages.hide()
