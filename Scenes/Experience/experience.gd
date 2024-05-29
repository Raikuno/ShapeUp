extends Node3D

var xpType
var randomDespawn = 10

func _ready():
	SignalsTrain.xPDespawn.connect(_onDespawn)
	
func initialize(positionEnemy,_xpType): #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	print("aparesco")
	global_transform.origin = positionEnemy
	xpType = _xpType
	match xpType:
		1:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CubeXP").hide()
			randomDespawn = 20
		2:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 35
		3:
			get_node("Experience/CubeXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 12
		4:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/CubeXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 28

func _onDespawn():
	if randi_range(1,randomDespawn) < 5 : 
		queue_free()
	
func _on_area_3d_body_entered(body):
	if SignalsTrain.has_signal("expPicked"):
		SignalsTrain.emit_signal("expPicked", xpType)
	playSound()
	hideAndDestroy()
	
func playSound():
	var sound
	if $Experience/SphereXP.visible:
		sound = load("res://Resources/Sounds/Experience/expPickUpSph.ogg")
	elif $Experience/PyramidXP.visible:
		sound = load("res://Resources/Sounds/Experience/expPickUpPyr.wav")
	elif $Experience/CubeXP.visible:
		sound = load("res://Resources/Sounds/Experience/expPickUpCub.ogg")
	elif $Experience/CilinderXP.visible:
		sound = load("res://Resources/Sounds/Experience/expPickUpCyl.ogg")
	$AudioStreamPlayer.stream = sound
	$AudioStreamPlayer.play()

func hideAndDestroy():
	$Experience.hide()
	$Area3D.queue_free()

func soundAndDestroy():
	queue_free()
