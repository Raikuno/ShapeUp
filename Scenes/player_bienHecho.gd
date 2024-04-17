extends CharacterBody3D
enum {MOVE, STATIC}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
enum {HEAD, BODY, RIGHT, LEFT, FEET}

var head
var body
var right
var left
var feet
var state
var animation

func _ready():
	changePolygon(AMEBA, HEAD)
	changePolygon(AMEBA, LEFT)
	changePolygon(AMEBA, RIGHT)
	changePolygon(AMEBA, BODY)
	changePolygon(AMEBA, FEET)

func _physics_process(delta):
	headLogic(delta)
	bodyLogic(delta)
	rightLogic(delta)
	leftLogic(delta)
	feetLogic(delta)
func changeState(newState):
	state = newState
	match state:
		MOVE:
			pass
		STATIC:
			pass
func changePolygon(newPolygon, type):
	match type:
		HEAD:
			head = newPolygon
		BODY:
			body = newPolygon
		FEET:
			feet = newPolygon
		RIGHT:
			right = newPolygon
		LEFT:
			left = newPolygon
func headLogic(delta):
	pass
func bodyLogic(delta):
	pass
func leftLogic(delta):
	pass
func rightLogic(delta):
	pass
func feetLogic(delta):
	pass
