extends CharacterBody3D
enum {MOVE, STATIC}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}

var head
var body
var right
var left
var feet
var state
var animation
var new_animation

func _ready():
	pass

func _physics_process(delta):
	pass
func changeState(newState):
	state = newState
	match state:
		MOVE:
			pass
		STATIC:
			pass
func changePolygon(newPolygon):
	polygon = newPolygon
	match polygon:
		
