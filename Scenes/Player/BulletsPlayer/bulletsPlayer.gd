extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}

var type
var direction
func _ready():
	match type:
		CUBE:
			position.x = $player_bienHecho.position.x
			position.y = $player_bienHecho.position.y
			position.z = $player_bienHecho.position.z
			rotation.x = $player_bienHecho.rotation.x
			rotation.y = $player_bienHecho.rotation.y
			rotation.z = $player_bienHecho.rotation.z
			scale.x = $player_bienHecho.scale.x
			scale.y = $player_bienHecho.scale.y
			scale.z = $player_bienHecho.scale.z
		PYRAMID:
			pass
		SPHERE:
			pass
		CYLINDER:
			pass
		AMEBA:
			pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func giveValue(newType, newDirection):
	type = newType
	direction = newDirection
