extends Control
enum {HEAD, BODY, RIGHT, LEFT, FEET}
var part1
var part2
var part3
func _ready():
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize(newParts): #node, figure, part
	part1 = newParts[0]
	var node : Node3D
	node = newParts[0]["resource"].duplicate()
	node.position = Vector3(0,0,0)
	node.scale = Vector3(1,1,1)
	node.rotation = Vector3(0,0,0)
	$part1Container/SubViewportContainer/SubViewport/Marker3D.add_child(node)
	match newParts[0]["identity"]:
		HEAD:
			$part1Container/part1.text = "Head"
		RIGHT:
			$part1Container/part1.text = "Right Arm"
		LEFT:
			$part1Container/part1.text = "Left Arm"
		FEET:
			$part1Container/part1.text = "Legs"
		BODY:
			$part1Container/part1.text = "Body"
	part2 = newParts[1]
	part3 = newParts[2]

func part1Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part1)
	queue_free()



func part2Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part2)
	queue_free()



func part3Selected():
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", part3)
	queue_free()


