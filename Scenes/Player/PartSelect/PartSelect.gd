extends Control
enum {HEAD, BODY, RIGHT, LEFT, FEET}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var part1
var part2
var part3
var partSelected
func _ready():
	get_tree().paused = true
	$AnimationPlayer.speed_scale = 2

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
	if partSelected == null:
		$AnimationPlayer2.play("moveContainer1")
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("vanish")
		$part1Container/button.queue_free()
		partSelected = part1

func part2Selected():
	if partSelected == null:
		$AnimationPlayer2.play("moveContainer2")
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("vanish")
		$part2Container/button.queue_free()
		partSelected = part2

func part3Selected():
	if partSelected == null:
		$AnimationPlayer2.play("moveContainer3")
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("vanish")
		$part3Container/button.queue_free()
		partSelected = part3

func endSelection(anim_name):
	get_tree().paused = false
	SignalsTrain.emit_signal("sendPart", partSelected)
	match partSelected:
		part1:
			$part3Container.queue_free()
			$part2Container.queue_free()
		part2:
			$part1Container.queue_free()
			$part3Container.queue_free()
		part3:
			$part1Container.queue_free()
			$part2Container.queue_free()
	$Label.queue_free()
	$ColorRect.queue_free()


func textAnimationFinish(anim_name):
	pass # Replace with function body.
