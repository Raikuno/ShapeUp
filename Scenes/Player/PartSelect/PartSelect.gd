extends Control
enum {HEAD, BODY, RIGHT, LEFT, FEET}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var part1
var part2
var part3
var partSelected

var lowMultiplier = 0.75
var mediumMultiplier = 1
var highMultiplier = 1.25
var reallyHighMultiplier = 1.5

var partMultiplier = {
	HEAD: {
		"health" : highMultiplier,
		"spd" : lowMultiplier,
		"dmg" : mediumMultiplier,
		"atkspd" : reallyHighMultiplier
	},
	RIGHT: {
		"health" : mediumMultiplier,
		"spd" : lowMultiplier,
		"dmg" : highMultiplier,
		"atkspd" : reallyHighMultiplier
	},
	LEFT: {
		"health" : mediumMultiplier,
		"spd" : lowMultiplier,
		"dmg" : highMultiplier,
		"atkspd" : reallyHighMultiplier
	},
	FEET: {
		"health" : lowMultiplier,
		"spd" : reallyHighMultiplier,
		"dmg" : mediumMultiplier,
		"atkspd" : highMultiplier
	},
	BODY: {
		"health" : reallyHighMultiplier,
		"spd" : highMultiplier,
		"dmg" : lowMultiplier,
		"atkspd" : mediumMultiplier
	}
}

func _ready():
	$Label.text = tr("SHAPEUP")
	$Timer2.start()
	$AnimationPlayer.speed_scale = 2
	$AnimationPlayer2.speed_scale= 2

func initialize(newParts): #node, figure, part
	part1 = newParts[0]
	part2 = newParts[1]
	part3 = newParts[2]

func setValues(part, newParts):
	var text = get_node(NodePath(part + "/button"))
	var bodyPart:Node3D
	var pathToNode : String = part
	match newParts["identity"]:
		HEAD:
			text.text = tr("HEAD")
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/headPosition"
		RIGHT:
			text.text = tr("RIGHT")
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/armsPosition"
		LEFT:
			text.text = tr("LEFT")
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/armsPosition"
		FEET:
			text.text = tr("FEET")
			pathToNode = pathToNode + "/SubViewportContainer/SubViewport/legsPosition"
		BODY:
			text.text = tr("BODY")
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

func showStats(nodePath:String, part):
	const BALANCEMODIFIER = 0.2
	var partLevel = get_node(NodePath(nodePath + "/PartLevel"))
	var figureLevel = get_node(NodePath(nodePath + "/FigureLevel"))
	var dmg = get_node(NodePath(nodePath + "/Dmg"))
	var spd = get_node(NodePath(nodePath + "/Spd"))
	var atkspd = get_node(NodePath(nodePath + "/Atkspd"))
	var health = get_node(NodePath(nodePath + "/Health"))
	var color : Color
	var pyramidLevel = get_node(NodePath(nodePath + "/Pyramid"))
	var sphereLevel = get_node(NodePath(nodePath + "/Sphere"))
	var cylinderLevel = get_node(NodePath(nodePath + "/Cylinider"))
	var cubeLevel = get_node(NodePath(nodePath + "/Cube"))
	partLevel.text = tr("UPGRADES") + " " + str(part["level"]["part"])
	pyramidLevel.text = pyramidLevel.text.replace("X", str(part["level"]["pyramid"]))
	sphereLevel.text = sphereLevel.text.replace("X", str(part["level"]["sphere"]))
	cylinderLevel.text = cylinderLevel.text.replace("X", str(part["level"]["cylinder"]))
	cubeLevel.text = cubeLevel.text.replace("X", str(part["level"]["cube"]))
	match part["figure"]:
		SPHERE:
			figureLevel.text = tr("LEVEL") + " " + str(part["level"]["sphere"])
			color = Color.SKY_BLUE
			dmg.text = dmg.text.replace("X", str((part["figureStat"]["damage"]  + (BALANCEMODIFIER * part["figureStat"]["damage"] * part["level"]["sphere"])) * partMultiplier[part["identity"]]["dmg"]))
			spd.text = spd.text.replace("X", str((part["figureStat"]["speed"]  + (BALANCEMODIFIER * part["figureStat"]["speed"] * part["level"]["sphere"])) * partMultiplier[part["identity"]]["spd"]))
			atkspd.text = atkspd.text.replace("X", str((part["figureStat"]["atqspd"] + (BALANCEMODIFIER * part["figureStat"]["atqspd"] * part["level"]["sphere"])) * partMultiplier[part["identity"]]["atkspd"]))
			health.text = health.text.replace("X", str((part["figureStat"]["health"] + (BALANCEMODIFIER * part["figureStat"]["health"] * part["level"]["sphere"])) * partMultiplier[part["identity"]]["health"]))
		PYRAMID:
			figureLevel.text = tr("LEVEL") + " " + str(part["level"]["pyramid"])
			color = Color.YELLOW
			dmg.text = dmg.text.replace("X", str((part["figureStat"]["damage"]  + (BALANCEMODIFIER * part["figureStat"]["damage"] * part["level"]["pyramid"])) * partMultiplier[part["identity"]]["dmg"]))
			spd.text = spd.text.replace("X", str((part["figureStat"]["speed"]  + (BALANCEMODIFIER * part["figureStat"]["speed"] * part["level"]["pyramid"])) * partMultiplier[part["identity"]]["spd"]))
			atkspd.text = atkspd.text.replace("X", str((part["figureStat"]["atqspd"] + (BALANCEMODIFIER * part["figureStat"]["atqspd"] * part["level"]["pyramid"])) * partMultiplier[part["identity"]]["atkspd"]))
			health.text = health.text.replace("X", str((part["figureStat"]["health"] + (BALANCEMODIFIER * part["figureStat"]["health"] * part["level"]["pyramid"])) * partMultiplier[part["identity"]]["health"]))
		CUBE:
			figureLevel.text = tr("LEVEL") + " " + str(part["level"]["cube"])
			color = Color.RED
			dmg.text = dmg.text.replace("X", str((part["figureStat"]["damage"]  + (BALANCEMODIFIER * part["figureStat"]["damage"] * part["level"]["cube"]))* partMultiplier[part["identity"]]["dmg"]))
			spd.text = spd.text.replace("X", str((part["figureStat"]["speed"]  + (BALANCEMODIFIER * part["figureStat"]["speed"] * part["level"]["cube"]))* partMultiplier[part["identity"]]["spd"]))
			atkspd.text = atkspd.text.replace("X", str((part["figureStat"]["atqspd"] + (BALANCEMODIFIER * part["figureStat"]["atqspd"] * part["level"]["cube"]))* partMultiplier[part["identity"]]["atkspd"]))
			health.text = health.text.replace("X", str((part["figureStat"]["health"] + (BALANCEMODIFIER * part["figureStat"]["health"] * part["level"]["cube"]))* partMultiplier[part["identity"]]["health"]))
		CYLINDER:
			figureLevel.text = tr("LEVEL") + " " + str(part["level"]["cylinder"])
			color = Color.WEB_GREEN
			dmg.text = dmg.text.replace("X", str((part["figureStat"]["damage"]  + (BALANCEMODIFIER * part["figureStat"]["damage"] * part["level"]["cylinder"]))* partMultiplier[part["identity"]]["dmg"]))
			spd.text = spd.text.replace("X", str((part["figureStat"]["speed"]  + (BALANCEMODIFIER * part["figureStat"]["speed"] * part["level"]["cylinder"]))* partMultiplier[part["identity"]]["spd"]))
			atkspd.text = atkspd.text.replace("X", str((part["figureStat"]["atqspd"] + (BALANCEMODIFIER * part["figureStat"]["atqspd"] * part["level"]["cylinder"]))* partMultiplier[part["identity"]]["atkspd"]))
			health.text = health.text.replace("X", str((part["figureStat"]["health"] + (BALANCEMODIFIER * part["figureStat"]["health"] * part["level"]["cylinder"]))* partMultiplier[part["identity"]]["health"]))
		AMEBA:
			figureLevel.text = tr("LEVEL") + " " + str(part["level"]["part"])
			color = Color.SADDLE_BROWN
			dmg.text = dmg.text.replace("X", str((part["figureStat"]["damage"]  + (BALANCEMODIFIER * part["figureStat"]["damage"] * part["level"]["part"]))* partMultiplier[part["identity"]]["dmg"]))
			spd.text = spd.text.replace("X", str((part["figureStat"]["speed"]  + (BALANCEMODIFIER * part["figureStat"]["speed"] * part["level"]["part"]))* partMultiplier[part["identity"]]["spd"]))
			atkspd.text = atkspd.text.replace("X", str((part["figureStat"]["atqspd"] + (BALANCEMODIFIER * part["figureStat"]["atqspd"] * part["level"]["part"]))* partMultiplier[part["identity"]]["atkspd"]))
			health.text = health.text.replace("X", str((part["figureStat"]["health"] + (BALANCEMODIFIER * part["figureStat"]["health"] * part["level"]["part"]))* partMultiplier[part["identity"]]["health"]))
	figureLevel.add_theme_color_override("font_color", color)
	dmg.add_theme_color_override("font_color", color)
	spd.add_theme_color_override("font_color", color)
	atkspd.add_theme_color_override("font_color", color)
	health.add_theme_color_override("font_color", color)
func part1Selected():
	if partSelected == null:
		$AudioStreamPlayer.play()
		$AnimationPlayer2.play("moveContainer1")
		$AnimationPlayer.play("RESET")
		$Label.hide()
		$part1Container/button.queue_free()
		$Part1Desc.queue_free()
		$Part2Desc.queue_free()
		$Part3Desc.queue_free()
		partSelected = part1

func part2Selected():
	if partSelected == null:
		$AudioStreamPlayer.play()
		$AnimationPlayer2.play("moveContainer2")
		$AnimationPlayer.play("RESET")
		$Label.hide()
		$part2Container/button.queue_free()
		$Part1Desc.queue_free()
		$Part2Desc.queue_free()
		$Part3Desc.queue_free()
		partSelected = part2

func part3Selected():
	if partSelected == null:
		$AudioStreamPlayer.play()
		$AnimationPlayer2.play("moveContainer3")
		$AnimationPlayer.play("RESET")
		$Label.hide()
		$part3Container/button.queue_free()
		$Part1Desc.queue_free()
		$Part2Desc.queue_free()
		$Part3Desc.queue_free()
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


func _on_timer_2_timeout():
	$Timer2.stop()
	get_tree().paused = true
	setValues("part1Container", part1)
	setValues("part2Container", part2)
	setValues("part3Container", part3)
	showStats("Part1Desc", part1)
	showStats("Part2Desc", part2)
	showStats("Part3Desc", part3)
