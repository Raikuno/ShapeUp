extends Node3D

var xpType
var hitboxEnable = false

func _ready():
	SignalsTrain.isTutorialExperienceEnable.connect(_onHitboxEnable)
	
func initialize(positionEnemy,_xpType, isHitboxEnable): #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	global_transform.origin = positionEnemy
	hitboxEnable = isHitboxEnable
	xpType = _xpType
	match xpType:
		1:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CubeXP").hide()
		2:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
		3:
			get_node("Experience/CubeXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CilinderXP").hide()
		4:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/CubeXP").hide()
			get_node("Experience/CilinderXP").hide()

func _onHitboxEnable():
	hitboxEnable = true	
	
func _on_area_3d_body_entered(body):
	if hitboxEnable:
		if SignalsTrain.has_signal("isTutorialExperience"):
			SignalsTrain.emit_signal("isTutorialExperience")
		if SignalsTrain.has_signal("expPicked"):
			SignalsTrain.emit_signal("expPicked", xpType)
		queue_free()
