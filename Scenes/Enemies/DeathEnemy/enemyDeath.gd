extends CharacterBody3D

var skinNumber = randi_range(1,2)
var enemyType #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide

var experience : PackedScene


func _ready():
	var animation = $Animation/AnimationPlayer
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "DondeCaemosGente":
		if skinNumber == 1:
			$Animation.get_child(0).play("Animation1")
		else:
			$Animation.get_child(0).play("Animation2")
	if skinNumber == 1:
		if anim_name == "DeathAnimation":
			queue_free()
	else:
		if anim_name == "DeathAnimation2":
			queue_free()
	

func enemyDeath():
	var position = global_transform.origin
	var experience = load("res://Scenes/Experience/experience.tscn")
	var experienceObject = experience.instantiate()
	experienceObject.initialize(position, enemyType)
	add_sibling(experienceObject)
	if skinNumber == 1:
		$Animation.get_child(0).play("DeathAnimation")
	else:
		$Animation.get_child(0).play("DeathAnimation2")
	

	
func initialize(start_position, _enemyType):
	enemyType = _enemyType
	global_position = start_position
	scale = Vector3(0.8,0.8,0.8)
	
	if skinNumber == 2:
		var skinChange = get_node("pivot").get_child(1)
		var skinOld = get_node("pivot").get_child(0)
		skinOld.hide()
		skinChange.show()

	


