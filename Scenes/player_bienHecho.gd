extends CharacterBody3D
enum {MOVE, STATIC}
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
enum {HEAD, BODY, RIGHT, LEFT, FEET}
#Partes del cuerpo
@onready var head = AMEBA
@onready var body = AMEBA
@onready var right = AMEBA
@onready var left = AMEBA
@onready var feet = AMEBA
@onready var state = STATIC
#Animaciones 
var animation
var animation_feet
var new_animation_feet
var new_animation
#Velocidad
var target_velocity = Vector3.ZERO
@export var speed = 8
#Apuntado
var rayOrigin = Vector3()
var rayEnd = Vector3()
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
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 2000
	var from = $Camera3D2.project_ray_origin(mouse_pos)
	var to = from + $Camera3D2.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var raycast_result = space.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	
	if not raycast_result.is_empty():
		var pos = raycast_result.position
		$pivot.look_at(Vector3(pos.x, position.y, pos.z), Vector3.UP)
	#Coomprobaciones de animaciones
	if animation != new_animation:
		animation = new_animation
		$body_animation.play(animation)
	if animation_feet != new_animation_feet:
		animation_feet = new_animation_feet
		print(animation_feet)
		$feet_animation.play(animation_feet)
	#Comprbaciones de estado
	if velocity != Vector3.ZERO and state == STATIC:
		changeState(MOVE)
	if velocity == Vector3.ZERO and state == MOVE:
		changeState(STATIC)
	#No se me ocurre otra etiqueta. Cosas, supongo
func changeState(newState):
	state = newState
	match state:
		MOVE:
			new_animation_feet = "feet"
		STATIC:
			new_animation_feet = "idle"
	print(new_animation_feet)
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
	var vectorDir = Vector3.ZERO
	var lookTo = Vector3.ZERO
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
		$legs.basis = Basis.looking_at(lookTo)
	target_velocity.x = vectorDir.x * speed
	target_velocity.z = vectorDir.z * speed
	velocity = target_velocity
	move_and_slide()
	
