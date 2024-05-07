extends Node
var arrayVectores = [Vector3(-27.768,1.2,35.369), Vector3(-34.71,1.2,44.158),Vector3(-72.145,1,53.832),Vector3(-45.474,1,40.171)]
var enemyDeath : PackedScene
const MAIN = "res://Scenes/Main/main.tscn"

func _ready():
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


func _on_start_pressed():
	get_tree().change_scene_to_file(MAIN)

func _on_exit_pressed():
	get_tree().quit()