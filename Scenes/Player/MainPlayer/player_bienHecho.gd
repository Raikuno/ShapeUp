extends CharacterBody3D
enum {MOVE, STATIC}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
enum {HEAD, BODY, RIGHT, LEFT, FEET}

var bulletDirection
#Multiplicadores
#--------------------Tipos de Multiplicadores--------------------------
@export var lowMultiplier = 0.75
@export var mediumMultiplier = 1
@export var highMultiplier = 1.25
@export var reallyHighMultiplier = 1.5
#--------------------Distribución en Cuerpo----------------------------
@onready var bodyHealth = reallyHighMultiplier
@onready var bodySpeed = highMultiplier
@onready var bodyDamage = lowMultiplier
@onready var bodyAtqSpd = mediumMultiplier
#----------------------------------------------------------------------
@onready var headHealth = highMultiplier
@onready var headSpeed = lowMultiplier
@onready var headDamage = mediumMultiplier
@onready var headAtqSpd = reallyHighMultiplier
#----------------------------------------------------------------------
@onready var armHealth = mediumMultiplier
@onready var armSpeed = lowMultiplier
@onready var armDamage = highMultiplier
@onready var armAtqSpd = reallyHighMultiplier
#----------------------------------------------------------------------
@onready var feetHealth = lowMultiplier
@onready var feetSpeed = reallyHighMultiplier
@onready var feetDamage = mediumMultiplier
@onready var feetAtqSpd = highMultiplier
#-------------------Valores en Figuras---------------------------------
#-------------------Barras y Niveles---------------------------------
@onready var cylinderXPBar = $Control/XPBars/CylinderXPBar
@onready var sphereXPBar = $Control/XPBars/SphereXPBar
@onready var cubeXPBar = $Control/XPBars/CubeXPBar
@onready var pyramidXPBar = $Control/XPBars/PyramidXPBar
@onready var cylinderLevel = $Control/XPBars/CylinderLevel
@onready var sphereLevel = $Control/XPBars/SphereLevel
@onready var cubeLevel = $Control/XPBars/CubeLevel
@onready var pyramidLevel = $Control/XPBars/PyramidLevel
@onready var theBar = $Control/TheBar
@onready var theBarCylinder = $Control/CylinderTheBar
@onready var theBarSphere = $Control/SphereTheBar
@onready var theBarCube = $Control/CubeTheBar
@onready var theBarPyramid = $Control/PyramidTheBar
#-------------------Barras de vida---------------------------------

@onready var healthBarCylinder = $Control/HealthBars/Cylinder/HealthBarCylinder
@onready var healthBarRectangleCylinder = $Control/HealthBars/Cylinder/HealthBarRectangleCylinder
@onready var healthBarSphere = $Control/HealthBars/Sphere/HealthBarSphere
@onready var healthBarRectangleSphere = $Control/HealthBars/Sphere/HealthBarRectangleSphere
@onready var healthBarCube = $Control/HealthBars/Cube/HealthBarCube
@onready var healthBarRectangleCube = $Control/HealthBars/Cube/HealthBarRectangleCube
@onready var healthBarPyramid = $Control/HealthBars/Pyramid/HealthBarPyramid
@onready var healthBarRectanglePyramid = $Control/HealthBars/Pyramid/HealthBarRectanglePyramid
var MouseCursorAmeba = load("res://Resources/MouseCursorAmeba.png")
var MouseCursorCube = load("res://Resources/MouseCursorCube.png")
var MouseCursorPyramid = load("res://Resources/MouseCursorPyramid.png")
var MouseCursorSphere = load("res://Resources/MouseCursorSphere.png")
var MouseCursorCylinder = load("res://Resources/MouseCursorCylinder.png")

var healthBarFigureInUse
var healthBarRectangleInUse
var tutorialPlayer = false
var xPNeededPerLevel = {
	0 : 5,   # 5
	1 : 10,  # 10
	2 : 20,  # 20
	3 : 40,  # 40
	4 : 80 ,  # 155
	5 : 100   # 255, lo que mide un byte guapísimo
}


# anotacion de carmelo, distintas dificultades. (FUMAO)
var sphereStat = {
	"health" : 5,
	"speed" : 15,
	"damage" : 5,
	"atqspd": 15
}
#----------------------------------------------------------------------
var cylinderStat = {
	"health" : 8,
	"speed" : 10,
	"damage" : 10,
	"atqspd": 12
}
#----------------------------------------------------------------------
var cubeStat = {
	"health" : 15,
	"speed" : 5,
	"damage" : 15,
	"atqspd": 5
}
#----------------------------------------------------------------------
var pyramidStat = {
	"health" : 12.5,
	"speed" : 7,
	"damage" : 15,
	"atqspd":6.5
}
#----------------------------------------------------------------------
var amebaStat = {
	"health" : 5,
	"speed" : 5,
	"damage" : 5,
	"atqspd":5
}
#----------------------------------------------------------------------
#Partes del cuerpo
var head = {
	"figure" : null,
	"resource": null,
	"figureStat": null,
	"experience": {
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"level": {
		"part" = 0,
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"identity" : HEAD
}
var body= {
	"figure" : null,
	"resource": null,
	"figureStat": null, 
	"experience": {
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"level": {
		"part" = 0,
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"identity" : BODY
}
var right= {
	"figure" : null,
	"resource": null,
	"figureStat": null,
	"experience": {
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"level": {
		"part" = 0,
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"identity" : RIGHT
}
var left= {
	"figure" : null,
	"resource": null,
	"figureStat": null,
		"experience": {
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"level": {
		"part" = 0,
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"identity" : LEFT
}
var feet= {
	"figure" : null,
	"resource": null,
	"figureStat": null,
	"experience": {
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"level": {
		"part" = 0,
		"cylinder" = 0,
		"cube" = 0,
		"sphere"= 0,
		"pyramid" = 0
		
	},
	"identity" : FEET
}
var generalXp = {
	"cylinder" = 0,
	"cube" = 0,
	"sphere"= 0,
	"pyramid" = 0
}
var upgrading
var state
#Animaciones 
var animation
var new_animation
#Velocidad
var target_velocity = Vector3.ZERO
#Stats
#-------------
var speed = 10 #(left["figureStat"]["speed"]* armSpeed)+(right["figureStat"]["speed"] * armSpeed)+(body["figureStat"]["speed"] * bodySpeed)+(head["figureStat"]["speed"] * headSpeed)+(feet["figureStat"]["speed"] * feetSpeed)
var health = 10#(left["figureStat"]["health"]* armHealth)+(right["figureStat"]["health"] * armHealth)+(body["figureStat"]["health"] * bodyHealth)+(head["figureStat"]["health"] * headHealth)+(feet["figureStat"]["health"] * feetHealth)
var healthRemaining
var damage = 10#(left["figureStat"]["damage"]* armDamage)+(right["figureStat"]["damage"] * armDamage)+(body["figureStat"]["damage"] * bodyDamage)+(head["figureStat"]["damage"] * headDamage)+(feet["figureStat"]["damage"] * feetDamage)
var atqSpeed = 10#(left["figureStat"]["atqspd"]* armAtqSpd)+(right["figureStat"]["atqspd"] * armAtqSpd)+(body["figureStat"]["atqspd"] * bodyAtqSpd)+(head["figureStat"]["atqspd"] * headAtqSpd)+(feet["figureStat"]["atqspd"] * feetAtqSpd)
#-------------
#Apuntado
var rayOrigin = Vector3()
var rayEnd = Vector3()
#Bullets
var intensity = 0
@onready var invisible = $Invisible
#kills uwu
@onready var kills = 0
#Variables que sostienen todo el peso del codigo sobre sus hombros
var alive = true #Te lo juro que esto hace falta, no quieres saber lo que pasa si lo quitas
@onready var shapingUp = false
func _ready():
	changePolygon(AMEBA, HEAD)
	changePolygon(AMEBA, BODY)
	changePolygon(CUBE, RIGHT)
	changePolygon(CUBE, LEFT)
	changePolygon(SPHERE, FEET)
	healthBarFigureInUse = healthBarSphere
	healthBarRectangleInUse = healthBarRectangleSphere
	resetStats()
	changeState(STATIC)
	SignalsTrain.hit.connect(onDamageTaken)
	SignalsTrain.expPicked.connect(onExpPicked)
	SignalsTrain.sumarKills.connect(onSumarKill)
	SignalsTrain.sendPart.connect(setUpgrade)
	
func setUpgrade(part):
	if tutorialPlayer:
		if SignalsTrain.has_signal("isTutorialExperience"):
			SignalsTrain.emit_signal("isTutorialExperience")
	upgrading = part
	setValueOnBar()
	var xPNeeded = xPNeededPerLevel[upgrading["level"]["part"]]
	changeTheBarSize(theBar,xPNeeded * 2) 
	changeTheBarSize(theBarSphere,xPNeeded) 
	changeTheBarSize(theBarCylinder,xPNeeded) 
	changeTheBarSize(theBarCube,xPNeeded) 
	changeTheBarSize(theBarPyramid,xPNeeded) 
	upgrading["level"]["part"] += 1
	$Control/XPBars/PartLevel.text = "%s: %s" % [whatPart(upgrading["identity"]), upgrading["level"]["part"]]
	resetStats()
	shapingUp = false
func whatPart(figure):
	match figure:
		0:
			return "Cabeza "
		1:
			return "Cuerpo "
		2:
			return "Brazo Derecho "
		3:
			return "Brazo Izquierdo "
		4:
			return "Piernas "

func howManyxPNeededForTheBar():
	match upgrading["level"]["part"]:
		0:  ##preguntar a jorge si sabe coger un indice específico de un puto mapa
			return xPNeededPerLevel["nivel1"]
		1:
			return xPNeededPerLevel["nivel2"]
		2:
			return xPNeededPerLevel["nivel3"]
		3:
			return xPNeededPerLevel["nivel4"]
		4:
			return xPNeededPerLevel["nivel5"]
		5:
			return 666
	return 500
func onSumarKill():
	kills += 1
	$Control/Kills.text = "💀%s" % kills
func onExpPicked(expType):  #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	match expType:
		1:
			upgrading["experience"]["cylinder"] +=1
			theBarCylinder.value = theBarCylinder.value + 1
		2:
			upgrading["experience"]["cube"] +=1
			theBarCube.value = theBarCube.value + 1
		3:
			upgrading["experience"]["sphere"] +=1
			theBarSphere.value = theBarSphere.value + 1
		4:
			upgrading["experience"]["pyramid"] +=1
			theBarPyramid.value = theBarPyramid.value + 1
	theBar.value = theBar.value + 1
	setValueOnBar()


func setValueOnBar(): #no tiene ningun sentido, mañana hablamos
	cylinderXPBar.value = upgrading["experience"]["cylinder"]
	sphereXPBar.value = upgrading["experience"]["sphere"]
	cubeXPBar.value = upgrading["experience"]["cube"]
	pyramidXPBar.value = upgrading["experience"]["pyramid"]
	cylinderLevel.text = "%s" % upgrading["level"]["cylinder"]
	sphereLevel.text = "%s" % upgrading["level"]["sphere"]
	cubeLevel.text = "%s" % upgrading["level"]["cube"]
	pyramidLevel.text = "%s" % upgrading["level"]["pyramid"]
	changeXPBarSize(cylinderXPBar,xPNeededPerLevel[upgrading["level"]["cylinder"]])
	changeXPBarSize(sphereXPBar,xPNeededPerLevel[upgrading["level"]["sphere"]])
	changeXPBarSize(cubeXPBar,xPNeededPerLevel[upgrading["level"]["cube"]])
	changeXPBarSize(pyramidXPBar,xPNeededPerLevel[upgrading["level"]["pyramid"]])

	#Este método es para recibir damages
func onDamageTaken(damageAmount):
	healthRemaining -= damageAmount
	print("Me queda: ", healthRemaining, " Recibí: ", damageAmount)
	
	for i in damageAmount:
		if healthBarRectangleInUse.value >  0:
			healthBarRectangleInUse.value -= 1
		else:
			healthBarFigureInUse.value -= 1
		if invisible.is_stopped():
			invisible.start()
		if healthRemaining <= 0 and alive:
			#gameOver() #Esto lo puse como funcion porque en un futuro esto irá después de la animación de muerte
			alive = false
			show()
			$rightArmPlayer.play("RESET")
			$rightArmPlayer.stop()
			$leftArmPlayer.play("RESET")
			$leftArmPlayer.stop()
			$feet_animation.play("RESET")
			$feet_animation.stop()
			$body_animation.play("death")

func gameOver():
	hide()
	Score.kills = kills
	Score.saveCharacter(head["figure"], body["figure"], right["figure"], left["figure"], feet["figure"])
	SignalsTrain.emit_signal("clubPenguinIsKill")

func _on_invisible_timeout():
	invisible.stop()
	
func _physics_process(delta):
	if alive:
		if Input.is_action_just_pressed("debug"): #Poner esto a null explota, prefiero llamarlo desde el método correspondiente
			selectPart()
		feetLogic(delta)
		aimingLogic(delta)
		attackLogic(delta)
		#Comprbaciones de estado
		if velocity != Vector3.ZERO and state == STATIC:
			changeState(MOVE)
		if velocity == Vector3.ZERO and state == MOVE:
			changeState(STATIC)
		if invisible.is_stopped() && healthRemaining > 0:
			show()
		else:
			hide()
		
func initializePartSelection():
	selectPart()

func initializePlayerTutorial():
	print("head")
	setUpgrade(head)
	tutorialPlayer = true
		
func selectPart():
	if !shapingUp:
		shapingUp = true
		var menuScene: PackedScene = load("res://Scenes/Player/PartSelect/PartSelect.tscn")
		var menuNode: Control = menuScene.instantiate()
		var map
		var parts = [head, left, right, body, feet]
		var result: Array
		while result.size() < 3:
			var toAdd = parts[randi_range(0, parts.size() - 1)]
			result.append(toAdd)
			parts.erase(toAdd)
		menuNode.initialize(result)
		add_sibling(menuNode)
func changeState(newState):
	state = newState
	match state:
		MOVE:
			match feet["figure"]:
				PYRAMID:
					animation = "pyramidFeetWalking"
				SPHERE:
					animation = "sphereFeetWalking"
				CUBE:
					animation = "cubeFeetWalking"
				CYLINDER:
					animation = "cylinderFeetWalking"
				AMEBA:
					animation = "amebaFeetWalking"
		STATIC:
			match feet["figure"]:
				PYRAMID:
					animation = "pyramidFeetIdle"
				SPHERE:
					animation = "sphereFeetIdle"
				CUBE:
					animation = "cubeFeetIdle"
				CYLINDER:
					animation = "cylinderFeetIdle"
				AMEBA:
					animation = "amebaFeetIdle"
			#new_animation_feet = "idle"
			
func getLevel(map):
	var result
	match map["figure"]:
		CUBE:
			result = map["level"]["cube"]
		CYLINDER:
			result = map["level"]["cylinder"]
		PYRAMID:
			result = map["level"]["pyramid"]
		SPHERE:
			result = map["level"]["sphere"]
		AMEBA:
			result = map["level"]["part"]
	return result
func resetStats():
	var balanceValue = 0.2
	var headLevel = getLevel(head)
	var rightLevel = getLevel(right)
	var leftLevel = getLevel(left)
	var feetLevel = getLevel(feet)
	var bodyLevel = getLevel(body)
	print("Cabesa: " + str(headLevel))
	print("Pisha: " + str(bodyLevel))
	print("Deresha: " + str(rightLevel))
	print("Isquierda: " + str(leftLevel))
	print("pieses: " + str(feetLevel))
	speed = (left["figureStat"]["speed"]* armSpeed + (left["figureStat"]["speed"]* armSpeed * leftLevel * balanceValue)) + (right["figureStat"]["speed"] * armSpeed + (right["figureStat"]["speed"] * armSpeed * rightLevel * balanceValue)) + (body["figureStat"]["speed"] * bodySpeed + (body["figureStat"]["speed"] * bodySpeed * bodyLevel * balanceValue)) + (head["figureStat"]["speed"] * headSpeed+ (head["figureStat"]["speed"] * headSpeed * headLevel * balanceValue)) + (feet["figureStat"]["speed"] * feetSpeed + (feet["figureStat"]["speed"] * feetSpeed * feetLevel * balanceValue))
	health = (left["figureStat"]["health"]* armHealth + (left["figureStat"]["health"]* armHealth * leftLevel * balanceValue))+(right["figureStat"]["health"] * armHealth + (right["figureStat"]["health"] * armHealth * rightLevel * balanceValue)) + (body["figureStat"]["health"] * bodyHealth + (body["figureStat"]["health"] * bodyHealth * bodyLevel * balanceValue)) + (head["figureStat"]["health"] * headHealth + (head["figureStat"]["health"] * headHealth * headLevel * balanceValue)) + (feet["figureStat"]["health"] * feetHealth + (feet["figureStat"]["health"] * feetHealth * feetLevel * balanceValue))
	damage = (left["figureStat"]["damage"]* armDamage + (left["figureStat"]["damage"]* armDamage * leftLevel * balanceValue))+(right["figureStat"]["damage"] * armDamage + (right["figureStat"]["damage"] * armDamage * rightLevel * balanceValue)) + (body["figureStat"]["damage"] * bodyDamage + (body["figureStat"]["damage"] * bodyDamage * bodyLevel * balanceValue)) + (head["figureStat"]["damage"] * headDamage + (head["figureStat"]["damage"] * headDamage * headLevel * balanceValue)) + (feet["figureStat"]["damage"] * feetDamage+ (feet["figureStat"]["damage"] * feetDamage * feetLevel * balanceValue))
	atqSpeed = (left["figureStat"]["atqspd"]* armAtqSpd + (left["figureStat"]["atqspd"]* armAtqSpd * leftLevel * balanceValue))+(right["figureStat"]["atqspd"] * armAtqSpd+(right["figureStat"]["atqspd"] * armAtqSpd * rightLevel * balanceValue)) + (body["figureStat"]["atqspd"] * bodyAtqSpd+ (body["figureStat"]["atqspd"] * bodyAtqSpd * bodyLevel * balanceValue)) + (head["figureStat"]["atqspd"] * headAtqSpd+ (head["figureStat"]["atqspd"] * headAtqSpd * headLevel * balanceValue)) + (feet["figureStat"]["atqspd"] * feetAtqSpd + (feet["figureStat"]["atqspd"] * feetAtqSpd * feetLevel * balanceValue))
	health = round(health * 3) # 5 veces más puta vida
	print("""
	Velocidad: %s
	Salud: %s
	Damage: %s
	ATQSpeed: %s
	""" % [speed, health, damage, atqSpeed])
	$rightArmPlayer.speed_scale = (1 + atqSpeed/80) 
	$leftArmPlayer.speed_scale = (1 + atqSpeed/80) 
	healthBarFigureInUse.hide()
	healthBarRectangleInUse.hide()
	match body["figure"]:
				SPHERE:
					setHealthBars(healthBarSphere,healthBarRectangleSphere)
				CUBE:
					setHealthBars(healthBarCube,healthBarRectangleCube)
				PYRAMID:
					setHealthBars(healthBarPyramid,healthBarRectanglePyramid)
				CYLINDER:
					setHealthBars(healthBarCylinder,healthBarRectangleCylinder)
				AMEBA:
					setHealthBars(healthBarSphere,healthBarRectangleSphere)
	if SignalsTrain.has_signal("xPDespawn"):
		SignalsTrain.emit_signal("xPDespawn")
	#Este método es para setear las barras de vida, usará el cuerpo para saber que sprite poner
func setHealthBars(figure,rectangle):
	healthRemaining = health
	#Seteamos cada barra con la mitad de la vida máxima
	figure.set_max(health / 2)
	rectangle.set_max(health / 2)
	print(health, "  ", health/2, "  ", health/2 + health/2)
	#Llenamos la barra de jugosa vida
	figure.value = (health / 2)
	rectangle.value = health / 2
	print(figure.value, "  ", figure.max_value)
	# Esto es para ahorrarnos 20 putas lineas al recibir daño
	healthBarFigureInUse = figure
	healthBarRectangleInUse = rectangle
	healthBarFigureInUse.show()
	healthBarRectangleInUse.show()

func changePolygon(newPolygon, type):
	match type:
		HEAD:
			head["figure"] = newPolygon
			if head["resource"] != null:
				head["resource"].hide()
			match newPolygon:
				SPHERE:
					head["resource"] = $"pivot/head/cabeza-esferaPlayer"
					head["figureStat"] = sphereStat
					Input.set_custom_mouse_cursor(MouseCursorSphere)
				CUBE:
					head["resource"] = $"pivot/head/cabeza-cuboPlayer"
					head["figureStat"] = cubeStat
					Input.set_custom_mouse_cursor(MouseCursorCube)
				PYRAMID:
					head["resource"] = $"pivot/head/cabeza-piramidePlayer"
					head["figureStat"] = pyramidStat
					Input.set_custom_mouse_cursor(MouseCursorPyramid)
				CYLINDER:
					head["resource"] = $"pivot/head/cabeza-cilindroPlayer"
					head["figureStat"] = cylinderStat
					Input.set_custom_mouse_cursor(MouseCursorCylinder)
				AMEBA:
					head["resource"] = $"pivot/head/cabeza-amebaPlayerMK2"
					head["figureStat"] = amebaStat
					Input.set_custom_mouse_cursor(MouseCursorAmeba)
			head["resource"].show()
		BODY:
			body["figure"] = newPolygon
			if body["resource"] != null:
				body["resource"].hide()
			match newPolygon:
				SPHERE:
					body["resource"] = $"pivot/body/esfera-CuerpoPlayer"
					body["figureStat"] = sphereStat
				CUBE:
					body["resource"] = $"pivot/body/cuerpo-cuboPlayer"
					body["figureStat"] = cubeStat
				PYRAMID:
					body["resource"] = $"pivot/body/cuerpo-piramidePlayer"
					body["figureStat"] = pyramidStat
				CYLINDER:
					body["resource"] = $"pivot/body/cuerpo-cilindroPlayer"
					body["figureStat"] = cylinderStat
				AMEBA:
					body["resource"] = $"pivot/body/cuerpo-amebaPlayerMKII"
					body["figureStat"] = amebaStat
			body["resource"].show()
		FEET:
			feet["figure"] = newPolygon
			if feet["resource"] != null:
				feet["resource"].hide()
			match newPolygon:
				SPHERE:
					feet["resource"] = $legs/spheres
					feet["figureStat"] = sphereStat
				CUBE:
					feet["resource"] = $legs/cubes
					feet["figureStat"] = cubeStat
				PYRAMID:
					feet["resource"] = $"legs/pyramid"
					feet["figureStat"] = pyramidStat
				CYLINDER:
					feet["resource"] = $legs/cilinders
					feet["figureStat"] = cylinderStat
				AMEBA:
					feet["resource"] = $legs/amebaEvil
					feet["figureStat"] = amebaStat
			feet["resource"].show()
		RIGHT:
			right["figure"] = newPolygon
			if right["resource"] != null:
				right["resource"].hide()
			match newPolygon:
				SPHERE:
					right["resource"] = $"pivot/rightArm/brazo-esferaPlayer"
					right["figureStat"] = sphereStat
				CUBE:
					right["resource"] = $"pivot/rightArm/brazo-cuboPlayer"
					right["figureStat"] = cubeStat
				PYRAMID:
					right["resource"] = $"pivot/rightArm/brazo-trianguloPlayer"
					right["figureStat"] = pyramidStat
				CYLINDER:
					right["resource"] = $"pivot/rightArm/brazo-cilindroPlayer"
					right["figureStat"] = cylinderStat
				AMEBA:
					right["resource"] = $"pivot/rightArm/brazo-amebaPlayerMKII2"
					right["figureStat"] = amebaStat
			right["resource"].show()
		LEFT:
			left["figure"] = newPolygon
			if left["resource"] != null:
				left["resource"].hide()
			match newPolygon:
				SPHERE:
					left["resource"] = $"pivot/leftArm/brazo-esferaPlayer"
					left["figureStat"] = sphereStat
				CUBE:
					left["resource"] = $"pivot/leftArm/brazo-cuboPlayer"
					left["figureStat"] = cubeStat
				PYRAMID:
					left["resource"] = $"pivot/leftArm/brazo-trianguloPlayer"
					left["figureStat"] = pyramidStat
				CYLINDER:
					left["resource"] = $"pivot/leftArm/brazo-cilindroPlayer"
					left["figureStat"] = cylinderStat
				AMEBA:
					left["resource"] = $"pivot/leftArm/brazo-amebaPlayerMKII"
					left["figureStat"] = amebaStat
			left["resource"].show()
func feetLogic(delta):
	var vectorDir = Vector3.ZERO
	var lookTo = Vector3.ZERO
	#animacion
	if Input.is_action_pressed("right"):
		vectorDir.x -= 1
		lookTo.z -= 1
	if Input.is_action_pressed("left"):
		vectorDir.x += 1
		lookTo.z += 1
	if Input.is_action_pressed("down"):
		vectorDir.z -= 1
		lookTo.x += 1
	if Input.is_action_pressed("up"):
		vectorDir.z += 1
		lookTo.x -= 1
	if vectorDir != Vector3.ZERO:
		vectorDir = vectorDir.normalized()
		feet["resource"].basis = Basis.looking_at(lookTo)
	target_velocity.x = vectorDir.x * speed
	target_velocity.z = vectorDir.z * speed
	velocity = target_velocity
	move_and_slide()
	if animation !=null:
		$feet_animation.play(animation)
func aimingLogic(delta):
	if rotation.y != 0:
		rotation.y = 0
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = $Camera3D2.project_ray_origin(mouse_pos)
	var to = from + $Camera3D2.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var raycast_result = space.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		bulletDirection = pos
		right["resource"].look_at(Vector3(pos.x, right["resource"].position.y, pos.z), Vector3.UP)
		left["resource"].look_at(Vector3(pos.x, left["resource"].position.y, pos.z), Vector3.UP)
		$pivot.look_at(Vector3(pos.x, position.y, pos.z), Vector3.UP)
func attackLogic(delta):
	match right["figure"]:
		SPHERE:
			$rightArmPlayer.play("sphereBullet")
		CUBE:
			$rightArmPlayer.play("cubeBullet")
		PYRAMID:
			$rightArmPlayer.play("pyramidBullet")
		CYLINDER:
			$rightArmPlayer.play("cylinderRight")
		AMEBA:
			$rightArmPlayer.play("AmebaRight")
			
	match left["figure"]:
		SPHERE:
			$leftArmPlayer.play("sphereBulletLeft")
		CUBE:
			$leftArmPlayer.play("cubeBulletLeft")
		PYRAMID:
			$leftArmPlayer.play("pyramidBulletLeft")
		CYLINDER:
			$leftArmPlayer.play("cylinderBulletLeft")
		AMEBA:
			$leftArmPlayer.play("amebaBulletLeft")

func fire(weapon, part, direction):
	var iNeedMoreBulletss: PackedScene
	var biggerWeapons:Node3D
	var variableDamage
	if direction=="right":
		iNeedMoreBulletss = load("res://Scenes/Player/BulletsPlayer/bulletsPlayer.tscn")
	elif direction=="left":
		iNeedMoreBulletss = load("res://Scenes/Player/BulletsPlayer/bulletsPlayerLeft.tscn")
	match weapon:
		SPHERE:
			variableDamage = 0.65
		AMEBA:
			variableDamage = 0.5
		PYRAMID:
			variableDamage = 1
		CUBE:
			variableDamage = 0.8
		CYLINDER:
			variableDamage = 0.3
	biggerWeapons = iNeedMoreBulletss.instantiate()
	biggerWeapons.initialize(weapon, damage * variableDamage, bulletDirection, part.global_position, part.global_rotation)
	add_sibling(biggerWeapons)

#Función que será llamada cada vez que finalice la animación de recarga. Esta animación y su velocidad determinarán la velocidad de ataque
func _on_right_arm_player_animation_finished(anim_name):
	fire(right["figure"], right["resource"], "right")
func _on_left_arm_player_animation_finished(anim_name):
	fire(left["figure"], left["resource"], "left")


func onLevelUp(xPBar, levelLabel, upgradingPart):
	levelLabel.text = "%s" % upgradingPart
	changeXPBarSize(xPBar,xPNeededPerLevel[upgradingPart])

func changeXPBarSize(xPBar, newSize):
	xPBar.set_max(newSize)
	
func changeTheBarSize(xPBar, newSize):
	xPBar.set_max(newSize)
	xPBar.value = 0
	
func _on_cylinder_xp_bar_value_changed(value):
	if value == cylinderXPBar.max_value:
		upgrading["level"]["cylinder"] += 1
		upgrading["experience"]["cylinder"] = 0
		onLevelUp(cylinderXPBar, cylinderLevel , upgrading["level"]["cylinder"])
		
func _on_pyramid_xp_bar_value_changed(value):
	if value == pyramidXPBar.max_value:
		upgrading["level"]["pyramid"] += 1
		upgrading["experience"]["pyramid"] = 0
		onLevelUp(pyramidXPBar, pyramidLevel , upgrading["level"]["pyramid"])


func _on_cube_xp_bar_value_changed(value):
	if value == cubeXPBar.max_value:
		upgrading["level"]["cube"] += 1
		upgrading["experience"]["cube"] = 0		
		onLevelUp(cubeXPBar, cubeLevel , upgrading["level"]["cube"])


func _on_sphere_xp_bar_value_changed(value):
	if value == sphereXPBar.max_value:
		upgrading["level"]["sphere"] += 1
		upgrading["experience"]["sphere"] = 0
		onLevelUp(sphereXPBar, sphereLevel , upgrading["level"]["sphere"])



func _on_the_bar_value_changed(value):
	if value == theBar.max_value && theBarSphere.value != theBarSphere.max_value && theBarCube.value != theBarCube.max_value && theBarPyramid.value != theBarPyramid.max_value && theBarCylinder.value != theBarCylinder.max_value:
		changePolygon(AMEBA, upgrading["identity"])
		selectPart()

func _on_sphere_the_bar_value_changed(value): #Priorizamos la barra de ameba, si salen ambas a la vez solo dejamos pasar ameba
	if value == theBarSphere.max_value:
		changePolygon(SPHERE, upgrading["identity"])
		selectPart()

func _on_cube_the_bar_value_changed(value):
	if value == theBarCube.max_value:
		changePolygon(CUBE, upgrading["identity"])
		selectPart()
		
func _on_pyramid_the_bar_value_changed(value):
	if value == theBarPyramid.max_value:
		changePolygon(PYRAMID, upgrading["identity"])
		selectPart()
		
		
func _on_cylinder_the_bar_value_changed(value):
	if value == theBarCylinder.max_value:
		changePolygon(CYLINDER, upgrading["identity"])
		selectPart()


func endDeathAnim(anim_name):
	if anim_name == "death":
		gameOver()

