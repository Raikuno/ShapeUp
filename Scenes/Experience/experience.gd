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
			randomDespawn = 25
		2:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 45
		3:
			get_node("Experience/CubeXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 15
		4:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/CubeXP").hide()
			get_node("Experience/CilinderXP").hide()
			randomDespawn = 35

func _onDespawn():
	if randi_range(1,randomDespawn) < 5 : 
		queue_free()
	
func _on_area_3d_body_entered(body):
	if SignalsTrain.has_signal("expPicked"):
		SignalsTrain.emit_signal("expPicked", xpType)
	if SignalsTrain.has_signal("isTutorialExperience"):
		SignalsTrain.emit_signal("isTutorialExperience")
	playSound()
	delete_exp()
func playSound():
	
	var sound = AudioStreamPlayer.new()
	if $Experience/SphereXP.visible:
		sound.stream = load("res://Resources/Sounds/Experience/expPickUpSph.ogg")
	elif $Experience/PyramidXP.visible:
		sound.stream = load("res://Resources/Sounds/Experience/expPickUpPyr.wav")
	elif $Experience/CubeXP.visible:
		sound.stream = load("res://Resources/Sounds/Experience/expPickUpPyr.wav")
	elif $Experience/CilinderXP.visible:
		sound.stream = load("res://Resources/Sounds/Experience/expPickUpCil.wav")
	
func delete_exp():
	$Area3D.queue_free()
	for i in $Experience.get_children():
		i.hide()
func _on_audio_stream_player_finished():
	queue_free()
