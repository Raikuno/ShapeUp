extends Node3D

var xpType

func initialize(_xpType): #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	xpType = _xpType
	match xpType:
		1:
			remove_child($SphereXP)
			remove_child($PyramidXP)
			remove_child($CubeXP)
		2:
			remove_child($SphereXP)
			remove_child($PyramidXP)
			remove_child($CilinderXP)
		3:
			remove_child($CubeXP)
			remove_child($PyramidXP)
			remove_child($CilinderXP)
		4:
			remove_child($SphereXP)
			remove_child($CubeXP)
			remove_child($CilinderXP)
			
func _on_area_3d_body_entered(body):
	if SignalsTrain.has_signal("expPicked"):
		SignalsTrain.emit_signal("expPicked", xpType)
	queue_free()
