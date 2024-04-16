extends CharacterBody3D

func _ready():
	# 0 = ameba / 1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	var head = randi_range(0,4)
	var body = randi_range(0,4)
	var leftArm = randi_range(0,4)
	var rightArm = randi_range(0,4)
	var legs = randi_range(0,4)
	match head:
		0:
			$"pivot/head/cabeza-amebaPlayer".show()
		1:
			$"pivot/head/cabeza-cilindroPlayer".show()
		2:
			$"pivot/head/cabeza-cuboPlayer".show()
		3:
			$"pivot/head/cabeza-esferaPlayer".show()
		4:
			$"pivot/head/cabeza-piramidePlayer".show()
	match body:
		0:
			$"pivot/body/cuerpo-amebaPlayer".show()
		1:
			$"pivot/body/cuerpo-cilindroPlayer".show()
		2:
			$"pivot/body/cuerpo-cuboPlayer".show()
		3:
			$"pivot/body/cuerpo-piramidePlayer".show()
		4:
			$"pivot/body/esfera-CuerpoPlayer".show()
	match leftArm:
		0:
			$"pivot/leftArm/brazo-amebaPlayer".show()
		1:
			$"pivot/leftArm/brazo-cilindroPlayer".show()
		2:
			$"pivot/leftArm/brazo-cuboPlayer".show()
		3:
			$"pivot/leftArm/brazo-esferaPlayer".show()
		4:
			$"pivot/leftArm/brazo-trianguloPlayer".show()
	match rightArm:
		0:
			$"pivot/rightArm/brazo-amebaPlayer".show()
		1:
			$"pivot/rightArm/brazo-cilindroPlayer".show()
		2:
			$"pivot/rightArm/brazo-cuboPlayer".show()
		3:
			$"pivot/rightArm/brazo-esferaPlayer".show()
		4:
			$"pivot/rightArm/brazo-trianguloPlayer".show()
	match legs:
		0:
			$pivot/legs/ameba.show()
		1:
			$pivot/legs/cilinders.show()
		2:
			$pivot/legs/cubes.show()
		3:
			$pivot/legs/spheres.show()
		4:
			$"pivot/legs/piernas-piramidePlayer".show()
		
	
	
