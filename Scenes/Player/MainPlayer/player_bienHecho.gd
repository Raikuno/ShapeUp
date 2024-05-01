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
@onready var legHealth = lowMultiplier
@onready var legSpeed = reallyHighMultiplier
@onready var legDamage = mediumMultiplier
@onready var legAtqSpd = highMultiplier
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
	"figureStat": null
}
var body= {
	"figure" : null,
	"resource": null,
	"figureStat": null
}
var right= {
	"figure" : null,
	"resource": null,
	"figureStat": null
}
var left= {
	"figure" : null,
	"resource": null,
	"figureStat": null
}
var feet= {
	"figure" : null,
	"resource": null,
	"figureStat": null
}
var state
#Animaciones 
var animation
var animation_feet
var new_animation_feet
var new_animation
#Velocidad
var target_velocity = Vector3.ZERO
#Stats
#-------------
var typeHealth
var typeDamage
var typeSpeed
var typeAtqSpd
#-------------
var speed = 30
var health = 5
var damage
var atqSpeed
#-------------
#Apuntado
var rayOrigin = Vector3()
var rayEnd = Vector3()
#Bullets
var intensity = 0
@onready var invisible = $Invisible

func _ready():
	changePolygon(AMEBA, HEAD)
	changePolygon(AMEBA, BODY)
	changePolygon(AMEBA, RIGHT)
	changePolygon(SPHERE, LEFT)
	changePolygon(AMEBA, FEET)
	SignalsTrain.hit.connect(onDamageTaken)

func onDamageTaken(damageAmount):
	health -= damageAmount
	print("Me queda: ", health, " Recibí: ", damageAmount)
	if invisible.is_stopped():
		invisible.start()
	
func _on_invisible_timeout():
	invisible.stop()
	
func _physics_process(delta):
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
			new_animation_feet = "feet"
		STATIC:
			new_animation_feet = "idle"


func changePolygon(newPolygon, type):
	match type:
		HEAD:
			if head["resource"] != null:
				head["resource"].hide()
			match newPolygon:
				SPHERE:
					head["resource"] = $"pivot/head/cabeza-esferaPlayer"
				CUBE:
					head["resource"] = $"pivot/head/cabeza-cuboPlayer"
				PYRAMID:
					head["resource"] = $"pivot/head/cabeza-piramidePlayer"
				CYLINDER:
					head["resource"] = $"pivot/head/cabeza-cilindroPlayer"
				AMEBA:
					head["resource"] = $"pivot/head/cabeza-amebaPlayerMK2"
			head["resource"].show()
		BODY:
			if body["resource"] != null:
				body["resource"].hide()
			match newPolygon:
				SPHERE:
					body["resource"] = $"pivot/body/esfera-CuerpoPlayer"
				CUBE:
					body["resource"] = $"pivot/body/cuerpo-cuboPlayer"
				PYRAMID:
					body["resource"] = $"pivot/body/cuerpo-piramidePlayer"
				CYLINDER:
					body["resource"] = $"pivot/body/cuerpo-cilindroPlayer"
				AMEBA:
					body["resource"] = $"pivot/body/cuerpo-amebaPlayerMKII"
			body["resource"].show()
		FEET:
			if feet["resource"] != null:
				feet["resource"].show()
			match newPolygon:
				SPHERE:
					feet["resource"] = $legs/spheres
				CUBE:
					feet["resource"] = $legs/cubes
				PYRAMID:
					feet["resource"] = $"legs/piernas-piramidePlayer"
				CYLINDER:
					feet["resource"] = $legs/cilinders
				AMEBA:
					feet["resource"] = $legs/amebaEvil
			feet["resource"].show()
		RIGHT:
			right["figure"] = newPolygon
			if right["resource"] != null:
				right["resource"].hide()
			match newPolygon:
				SPHERE:
					right["resource"] = $"pivot/rightArm/brazo-esferaPlayer"
				CUBE:
					right["resource"] = $"pivot/rightArm/brazo-cuboPlayer"
				PYRAMID:
					right["resource"] = $"pivot/rightArm/brazo-trianguloPlayer"
				CYLINDER:
					right["resource"] = $"pivot/rightArm/brazo-cilindroPlayer"
				AMEBA:
					right["resource"] = $"pivot/rightArm/brazo-amebaPlayerMKII2"
			right["resource"].show()
		LEFT:
			left["figure"] = newPolygon
			if left["resource"] != null:
				left["resource"].hide()
			match newPolygon:
				SPHERE:
					left["resource"] = $"pivot/leftArm/brazo-esferaPlayer"
				CUBE:
					left["resource"] = $"pivot/leftArm/brazo-cuboPlayer"
				PYRAMID:
					left["resource"] = $"pivot/leftArm/brazo-trianguloPlayer"
				CYLINDER:
					left["resource"] = $"pivot/leftArm/brazo-cilindroPlayer"
				AMEBA:
					left["resource"] = $"pivot/leftArm/brazo-amebaPlayerMKII"
			left["resource"].show()
func feetLogic(delta):
	var vectorDir = Vector3.ZERO
	var lookTo = Vector3.ZERO
	#animacion
	if Input.is_action_pressed("right"):
		vectorDir.z += 1
		lookTo.x += 1
	if Input.is_action_pressed("left"):
		vectorDir.z -= 1
		lookTo.x -= 1
	if Input.is_action_pressed("down"):
		vectorDir.x -= 1
		lookTo.z += 1
	if Input.is_action_pressed("up"):
		vectorDir.x += 1
		lookTo.z -= 1
	if vectorDir != Vector3.ZERO:
		vectorDir = vectorDir.normalized()
		$legs.basis = Basis.looking_at(lookTo)
	target_velocity.x = vectorDir.x * speed
	target_velocity.z = vectorDir.z * speed
	velocity = target_velocity
	move_and_slide()
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
			pass

func fire(weapon, part):
	var iNeedMoreBulletss: PackedScene = load("res://Scenes/Player/BulletsPlayer/bulletsPlayer.tscn")
	var biggerWeapons:Node3D
	biggerWeapons = iNeedMoreBulletss.instantiate()
	biggerWeapons.initialize(weapon, $pivot.basis, part.global_position, part.global_rotation)
	add_sibling(biggerWeapons)

#Función que será llamada cada vez que finalice la animación de recarga. Esta animación y su velocidad determinarán la velocidad de ataque
func _on_right_arm_player_animation_finished(anim_name):
	fire(right["figure"], right["resource"])
func _on_left_arm_player_animation_finished(anim_name):
	fire(left["figure"], left["resource"])
