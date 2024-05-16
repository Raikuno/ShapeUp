extends Control
enum {HEAD, BODY, RIGHT, LEFT, FEET}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var part1
var part2
var part3
func _ready():
	get_tree().paused = true

func initialize(newParts): #node, figure, part
	part1 = newParts[0]
	part2 = newParts[1]
	part3 = newParts[2]
	setValues("part1Container", part1)
	setValues("part2Container", part2)
	setValues("part3Container", part3)
func setValues(part, newParts):
	var text = get_node(NodePath(part + "/button"))
	var bodyPart:Node3D
	var pathToNode : String = part
	match newParts["identity"]:
		HEAD:
			text.text = "Head"
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/headPosition"
		RIGHT:
			text.text = "Right Arm"
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/armsPosition"
		LEFT:
			text.text = "Left Arm"
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/armsPosition"
		FEET:
			text.text = "Legs"
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/legsPosition"
		BODY:
			text.text = "Body"
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/bodyPosition"
	
	match newParts["figure"]:
		CUBE:
			pathToNode = pathToNode + "/cubo"
		PYRAMID:
			pathToNode = pathToNode + "/piramide"
		CYLINDER:
			pathToNode = pathToNode + "/cilindro"
		SPHERE:
			pathToNode = pathToNode + "/esfera"
		AMEBA:
			pathToNode = pathToNode + "/ameba"
	bodyPart = get_node(pathToNode)
	bodyPart.show()

func part1Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part1)
	queue_free()

func manager(msg):
	pass

func part2Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part2)
	queue_free()



func part3Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part3)
	queue_free()


