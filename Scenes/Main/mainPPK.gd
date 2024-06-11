extends Node
var arrayVectores = [Vector3(-27.768,1.2,35.369), Vector3(-34.71,1.2,44.158),Vector3(-72.145,1,53.832),Vector3(-45.474,1,40.171)]
var enemyDeath : PackedScene
const MAIN = "res://Scenes/Main/main.tscn"
const TUTORIAL = "res://Scenes/Tutorial/tutorial.tscn"
const SCOREBOARD = "res://Scenes/ScoreBoard/ScoreList.tscn"
func _ready():
	setTexts()
	$Menu/VolumeNum.text =tr("VOLUMEN") + ": " + str(RoomManager.globalVolume+30)
	$Menu/HSlider.value = RoomManager.globalVolume
	for vector3 in arrayVectores:
		var enemyRandom = randi_range(1,4) #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
		match enemyRandom:
			1:
				enemyDeath = load("res://Scenes/Enemies/DeathEnemy/enemyCylinderDeath.tscn")
			2:
				enemyDeath = load("res://Scenes/Enemies/DeathEnemy/enemyCubeDeath.tscn")
			3:
				enemyDeath = load("res://Scenes/Enemies/DeathEnemy/enemySphereDeath.tscn")
			4:
				enemyDeath = load("res://Scenes/Enemies/DeathEnemy/enemyPyramidDeath.tscn")
		var enemyObject = enemyDeath.instantiate()

		enemyObject.initialize(vector3, enemyRandom) 
		add_child(enemyObject)

	
func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func setTexts():
	$Menu/Start.text = tr("START")
	$Menu/Exit.text = tr("EXIT")
	$Menu/ScoreBoard.text = tr("CLAS")
	$Menu/Tutorial.text = tr("TUTORIAL_BUTTON")
	$Menu/Credits.text = tr("CREDITS_BUTTON")
	$Menu/VolumeNum.text = tr("VOLUMEN") + ": " + str(RoomManager.globalVolume+30)
	$Menu/credits.text = tr("CREDITS") + "\nRaikuno (Jorge Rojas)\nPPKRex (Jose Carlos Pérez)"
	$Menu/credits2.text = tr("CREDITS2")

func _on_start_pressed():
	var needsReset = get_tree().get_nodes_in_group("needsReset")
	queue_free()
	RoomManager.changeRoom(MAIN)

func _on_exit_pressed():
	get_tree().quit()


func _on_tutorial_pressed():
	queue_free()
	RoomManager.changeRoom(TUTORIAL)


func scoreboard():
	RoomManager.changeRoom(SCOREBOARD)
	queue_free()


func volumeChanged(value_changed):
	var master_bus = AudioServer.get_bus_index("Master")
	RoomManager.globalVolume = value_changed
	$Menu/VolumeNum.text =tr("VOLUMEN") + ": " + str(RoomManager.globalVolume+30)
	AudioServer.set_bus_volume_db(master_bus, value_changed)


func _on_music_disable_toggled(toggled_on):
	Score.disableMusic = toggled_on


func credits_pressed():
	$AnimationPlayer.play("credits_show")



func back_credits():
	$AnimationPlayer.play_backwards("credits_show")


func spanish():
	Score.setLanguageSpanish()
	setTexts()



func english():
	Score.setLanguageEnglish()
	setTexts()
