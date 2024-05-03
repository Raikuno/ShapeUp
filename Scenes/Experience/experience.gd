extends Node3D

var xpType

func initialize(positionEnemy,_xpType): #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	global_transform.origin = positionEnemy
	xpType = _xpType
	match xpType:
		1:
			get_node("Experience/SphereXP").hide()
			get_node("Experience/PyramidXP").hide()
			get_node("Experience/CubeXP").hide()
			#remove_child($Experience/SphereXP)
			#remove_child($Experience/PyramidXP)
			#remove_child($Experience/CubeXP)
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
			
func _on_area_3d_body_entered(body):
	if SignalsTrain.has_signal("expPicked"):
		SignalsTrain.emit_signal("expPicked", xpType)
	queue_free()
