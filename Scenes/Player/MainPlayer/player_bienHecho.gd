extends CharacterBody3D
enum {MOVE, STATIC}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
enum {HEAD, BODY, RIGHT, LEFT, FEET}
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
	}
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
	}
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
	}
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
	}
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
	}
}
var generalXp = {
	"cylinder" = 0,
	"cube" = 0,
	"sphere"= 0,
	"pyramid" = 0
}
var upgrading = HEAD
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
var damage = 10#(left["figureStat"]["damage"]* armDamage)+(right["figureStat"]["damage"] * armDamage)+(body["figureStat"]["damage"] * bodyDamage)+(head["figureStat"]["damage"] * headDamage)+(feet["figureStat"]["damage"] * feetDamage)
var atqSpeed = 10#(left["figureStat"]["atqspd"]* armAtqSpd)+(right["figureStat"]["atqspd"] * armAtqSpd)+(body["figureStat"]["atqspd"] * bodyAtqSpd)+(head["figureStat"]["atqspd"] * headAtqSpd)+(feet["figureStat"]["atqspd"] * feetAtqSpd)
#-------------
#Apuntado
var rayOrigin = Vector3()
var rayEnd = Vector3()
#Bullets
var intensity = 0
@onready var invisible = $Invisible

func _ready():
	changePolygon(SPHERE, HEAD)
	changePolygon(SPHERE, BODY)
	changePolygon(CUBE, RIGHT)
	changePolygon(SPHERE, LEFT)
	changePolygon(PYRAMID, FEET)
	resetStats()
	changeState(STATIC)
	SignalsTrain.hit.connect(onDamageTaken)
	SignalsTrain.expPicked.connect(onExpPicked)
	
func onExpPicked(expType):  #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
	match expType:
		1:
			match upgrading:
				HEAD:
					head["experience"]["cylinder"] +=1
				RIGHT:
					right["experience"]["cylinder"] +=1
				LEFT:
					left["experience"]["cylinder"] +=1
				BODY:
					body["experience"]["cylinder"] +=1
				FEET:
					feet["experience"]["cylinder"] +=1
		2:
			match upgrading:
				HEAD:
					head["experience"]["cube"] +=1
				RIGHT:
					right["experience"]["cube"] +=1 
				LEFT:
					left["experience"]["cube"] +=1
				BODY:
					body["experience"]["cube"] +=1
				FEET:
					feet["experience"]["cube"] +=1
		3:
			match upgrading:
				HEAD:
					head["experience"]["sphere"] +=1
				RIGHT:
					right["experience"]["sphere"] +=1
				LEFT:
					left["experience"]["sphere"] +=1
				BODY:
					body["experience"]["sphere"] +=1
				FEET:
					feet["experience"]["sphere"] +=1
		4:
			match upgrading:
					HEAD:
						head["experience"]["pyramid"] +=1
					RIGHT:
						right["experience"]["pyramid"] +=1
					LEFT:
						left["experience"]["pyramid"] +=1
					BODY:
						body["experience"]["pyramid"] +=1
					FEET:
						feet["experience"]["pyramid"] +=1
	print("""
	CylinderXp: %s
	CubeXp: %s
	ShpereXp: %s
	PyramidXp: %s
	""" % [head["experience"]["cylinder"], head["experience"]["cube"], head["experience"]["sphere"], head["experience"]["pyramid"]])

func onDamageTaken(damageAmount):
	health -= damageAmount
	print("Me queda: ", health, " Recibí: ", damageAmount)
	if invisible.is_stopped():
		invisible.start()
	
func _on_invisible_timeout():
	invisible.stop()
	
func _physics_process(delta):
	if health <= 0:
		queue_free()
	feetLogic(delta)
	aimingLogic(delta)
	attackLogic(delta)
	#Comprbaciones de estado
	if velocity != Vector3.ZERO and state == STATIC:
		changeState(MOVE)
	if velocity == Vector3.ZERO and state == MOVE:
		changeState(STATIC)
	if invisible.is_stopped():
		show()
	else:
		hide()

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
			
			
	

func resetStats():
	speed = (left["figureStat"]["speed"]* armSpeed)+(right["figureStat"]["speed"] * armSpeed)+(body["figureStat"]["speed"] * bodySpeed)+(head["figureStat"]["speed"] * headSpeed)+(feet["figureStat"]["speed"] * feetSpeed)
	health = (left["figureStat"]["health"]* armHealth)+(right["figureStat"]["health"] * armHealth)+(body["figureStat"]["health"] * bodyHealth)+(head["figureStat"]["health"] * headHealth)+(feet["figureStat"]["health"] * feetHealth)
	damage = (left["figureStat"]["damage"]* armDamage)+(right["figureStat"]["damage"] * armDamage)+(body["figureStat"]["damage"] * bodyDamage)+(head["figureStat"]["damage"] * headDamage)+(feet["figureStat"]["damage"] * feetDamage)
	atqSpeed = (left["figureStat"]["atqspd"]* armAtqSpd)+(right["figureStat"]["atqspd"] * armAtqSpd)+(body["figureStat"]["atqspd"] * bodyAtqSpd)+(head["figureStat"]["atqspd"] * headAtqSpd)+(feet["figureStat"]["atqspd"] * feetAtqSpd)
	print("""
	Velocidad: %s
	Salud: %s
	Damage: %s
	ATQSpeed: %s
	""" % [speed, health, damage, atqSpeed])
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
				CUBE:
					head["resource"] = $"pivot/head/cabeza-cuboPlayer"
					head["figureStat"] = cubeStat
				PYRAMID:
					head["resource"] = $"pivot/head/cabeza-piramidePlayer"
					head["figureStat"] = pyramidStat
				CYLINDER:
					head["resource"] = $"pivot/head/cabeza-cilindroPlayer"
					head["figureStat"] = cylinderStat
				AMEBA:
					head["resource"] = $"pivot/head/cabeza-amebaPlayerMK2"
					head["figureStat"] = amebaStat
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
				feet["resource"].show()
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
		pass
		$feet_animation.play(animation)
func aimingLogic(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = $Camera3D2.project_ray_origin(mouse_pos)
	var to = from + $Camera3D2.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var raycast_result = space.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		intensity = abs(position) - abs(pos)
		#print(intensity)
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
			pass
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
			pass
		AMEBA:
			$leftArmPlayer.play("amebaBulletLeft")

func fire(weapon, part):
	var iNeedMoreBulletss: PackedScene = load("res://Scenes/Player/BulletsPlayer/bulletsPlayer.tscn")
	var biggerWeapons:Node3D
	biggerWeapons = iNeedMoreBulletss.instantiate()
	biggerWeapons.initialize(weapon, $pivot.basis, damage, part.global_position, part.global_rotation)
	add_sibling(biggerWeapons)

#Función que será llamada cada vez que finalice la animación de recarga. Esta animación y su velocidad determinarán la velocidad de ataque
func _on_right_arm_player_animation_finished(anim_name):
	fire(right["figure"], right["resource"])
func _on_left_arm_player_animation_finished(anim_name):
	fire(left["figure"], left["resource"])
