extends Node3D

var xpType
var randomDespawn = 10

func _ready():
	SignalsTrain.xPDespawn.connect(_onDespawn)
	
func initialize(positionEnemy,_xpType): #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
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
	queue_free()