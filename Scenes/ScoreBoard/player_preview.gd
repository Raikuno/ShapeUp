extends CharacterBody3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}

func changeVisibility():
	match Score.character["head"]:
		CUBE:
			$"pivot/head/cabeza-cuboPlayer".show()
		PYRAMID:
			$"pivot/head/cabeza-piramidePlayer".show()
		SPHERE:
			$"pivot/head/cabeza-esferaPlayer".show()
		CYLINDER:
			$"pivot/head/cabeza-cilindroPlayer".show()
		AMEBA:
			$"pivot/head/cabeza-amebaPlayer".show()
	match Score.character["body"]:
		CUBE:
			$"pivot/body/cuerpo-cuboPlayer".show()
		PYRAMID:
			$"pivot/body/cuerpo-piramidePlayer".show()
		SPHERE:
			$"pivot/body/esfera-CuerpoPlayer".show()
		CYLINDER:
			$"pivot/body/cuerpo-cilindroPlayer".show()
		AMEBA:
			$"pivot/body/cuerpo-amebaPlayerMKII".show()
	match Score.character["left"]:
		CUBE:
			$"pivot/leftArm/brazo-cuboPlayer".show()
		PYRAMID:
			$"pivot/leftArm/brazo-trianguloPlayer".show()
		SPHERE:
			$"pivot/leftArm/brazo-esferaPlayer".show()
		CYLINDER:
			$"pivot/leftArm/brazo-cilindroPlayer".show()
		AMEBA:
			$"pivot/leftArm/brazo-amebaPlayerMKII".show()
	match Score.character["right"]:
		CUBE:
			$"pivot/rightArm/brazo-cuboPlayer".show()
		PYRAMID:
			$"pivot/rightArm/brazo-trianguloPlayer".show()
		SPHERE:
			$"pivot/rightArm/brazo-esferaPlayer".show()
		CYLINDER:
			$"pivot/rightArm/brazo-cilindroPlayer".show()
		AMEBA:
			$"pivot/rightArm/brazo-amebaPlayerMKII2".show()
	match Score.character["feet"]:
		CUBE:
			$legs/cubes.show()
		PYRAMID:
			$legs/pyramid.show()
		SPHERE:
			$legs/spheres.show()
		CYLINDER:
			$legs/cilinders.show()
		AMEBA:
			$legs/amebaEvil.show()
	print(Score.character)
