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
@onready var sphereHealth = 5 # anotacion de carmelo, distintas dificultades. (FUMAO)
@onready var sphereSpeed = 15
@onready var sphereDamage = 5
@onready var sphereAtqSpd = 15
#----------------------------------------------------------------------
@onready var cylinderHealth = 8
@onready var cylinderSpeed = 10
@onready var cylinderDamage = 10
@onready var cylinderAtqSpd = 12
#----------------------------------------------------------------------
@onready var cubeHealth = 15
@onready var cubeSpeed = 5
@onready var cubeDamage = 15
@onready var cubeAtqSpd = 5
#----------------------------------------------------------------------
@onready var pyramidHealth = 12.5
@onready var pyramidSpeed = 7
@onready var pyramidDamage = 15
@onready var pyramidAtqSpd = 6.5
#----------------------------------------------------------------------

#Partes del cuerpo
var head
var body
var right
var left
var feet
var rightWeapon
var leftWeapon
var state
#Animaciones 
var animation
var animation_feet
var new_animation_feet
var new_animation
#Velocidad
var target_velocity = Vector3.ZERO
@export var speed = 30
#Vida
@export var health = 100
#Apuntado
var rayOrigin = Vector3()
var rayEnd = Vector3()
#Bullets

#porro
var porro1 = false
var porro2 = false

@onready var invisible = $Invisible

func _ready():
	changePolygon(AMEBA, HEAD)
	changePolygon(AMEBA, BODY)
	changePolygon(CUBE, RIGHT)
	changePolygon(CUBE, LEFT)
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
			if head != null:
				head.hide()
			match newPolygon:
				SPHERE:
					head = $"pivot/head/cabeza-esferaPlayer"
				CUBE:
					head = $"pivot/head/cabeza-cuboPlayer"
				PYRAMID:
					head = $"pivot/head/cabeza-piramidePlayer"
				CYLINDER:
					head = $"pivot/head/cabeza-cilindroPlayer"
				AMEBA:
					head = $"pivot/head/cabeza-amebaPlayerMK2"
			head.show()
		BODY:
			if body != null:
				body.hide()
			match newPolygon:
				SPHERE:
					body = $"pivot/body/esfera-CuerpoPlayer"
				CUBE:
					body = $"pivot/body/cuerpo-cuboPlayer"
				PYRAMID:
					body = $"pivot/body/cuerpo-piramidePlayer"
				CYLINDER:
					body = $"pivot/body/cuerpo-cilindroPlayer"
				AMEBA:
					body = $"pivot/body/cuerpo-amebaPlayerMKII"
			body.show()
		FEET:
			if feet != null:
				feet.show()
			match newPolygon:
				SPHERE:
					feet = $legs/spheres
				CUBE:
					feet = $legs/cubes
				PYRAMID:
					feet = $"legs/piernas-piramidePlayer"
				CYLINDER:
					feet = $legs/cilinders
				AMEBA:
					feet = $legs/amebaEvil
			feet.show()
		RIGHT:
			rightWeapon = newPolygon
			if right != null:
				right.hide()
			match newPolygon:
				SPHERE:
					right = $"pivot/rightArm/brazo-esferaPlayer"
				CUBE:
					right = $"pivot/rightArm/brazo-cuboPlayer"
				PYRAMID:
					right = $"pivot/rightArm/brazo-trianguloPlayer"
				CYLINDER:
					right = $"pivot/rightArm/brazo-cilindroPlayer"
				AMEBA:
					right = $"pivot/rightArm/brazo-amebaPlayerMKII"
			right.show()
		LEFT:
			leftWeapon = newPolygon
			if left != null:
				left.hide()
			match newPolygon:
				SPHERE:
					left = $"pivot/leftArm/brazo-esferaPlayer"
				CUBE:
					left = $"pivot/leftArm/brazo-cuboPlayer"
				PYRAMID:
					left = $"pivot/leftArm/brazo-trianguloPlayer"
				CYLINDER:
					left = $"pivot/leftArm/brazo-cilindroPlayer"
				AMEBA:
					left = $"pivot/leftArm/brazo-amebaPlayerMKII"
			left.show()
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
		$pivot.look_at(Vector3(pos.x, position.y, pos.z), Vector3.UP)
func attackLogic(delta):
	match rightWeapon:
		SPHERE:
			pass
		CUBE:
			$rightArmPlayer.play("cubeBullet")
		PYRAMID:
			$rightArmPlayer.play("pyramidBullet")
		CYLINDER:
			pass
		AMEBA:
			pass
			
	match leftWeapon:
		SPHERE:
			pass
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
	fire(rightWeapon, right)
func _on_left_arm_player_animation_finished(anim_name):
	fire(leftWeapon, left)






