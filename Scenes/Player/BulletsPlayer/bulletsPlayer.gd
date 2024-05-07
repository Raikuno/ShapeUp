extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var type
@onready var onFloor = false
@onready var collision = true
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var damage = 50   # cada tipo de brazo va a tener un multiplicador al daño base del jugador, por ejemplo circulo hará un 0.75 del daño base y cuadrado un 1.25
@onready var cubeHeight = 0.8
var getFixedBoy = false
func _ready():
	pass
func _process(delta):
	pass
func callBullet():
		match type:
			CUBE:
				$brazoCubo.show()
				remove_child($brazoTriangulo)
				remove_child($brazoEsfera)
				remove_child($brazoAmeba)
				remove_child($bracoCilindro)
			PYRAMID:
				$brazoTriangulo.show()
				remove_child($brazoCubo)
				remove_child($brazoEsfera)
				remove_child($brazoAmeba)
				remove_child($bracoCilindro)
			SPHERE:
				$brazoEsfera.show()
				remove_child($brazoCubo)
				remove_child($brazoTriangulo)
				remove_child($brazoAmeba)
				remove_child($bracoCilindro)
			CYLINDER:
				getFixedBoy = true
				$bracoCilindro.show()
				remove_child($bracoAmeba)
				remove_child($brazoCubo)
				remove_child($brazoTriangulo)
				remove_child($brazoSphere)
				remove_child($brazoAmeba/CollisionShape3D)
				
			AMEBA:
				$brazoAmeba.show()
				remove_child($brazoCubo)
				remove_child($brazoTriangulo)
				remove_child($brazoSphere)
				remove_child($bracoCilindro)

func initialize(newType, direction, newDamage, newPosition = position, newRotation = rotation):
	var downer : float
	if newType == SPHERE:
		downer = 1.5
	else:
		downer = 1
	position = Vector3(newPosition.x, newPosition.y - downer, newPosition.z)
	rotation = newRotation
	type = newType
	basis = direction
	damage = newDamage
	callBullet()
func _physics_process(delta):
	match type:
		SPHERE:
			sphereLogic(delta)
		CYLINDER:
			cylinderLogic(delta)
		CUBE:
			cubeLogic(delta)
		PYRAMID:
			pyramidLogic(delta)
		AMEBA:
			amebaLogic(delta)
func _on_visible_on_screen_notifier_3d_screen_exited():
	$outOfBounds.start()
func destroy():
	queue_free()
func pyramidLogic(delta):
	var direction = global_transform.basis.z.normalized()
	var displacement : Vector3 = direction * -50 * delta
	global_transform.origin += displacement
func cubeLogic(delta):
	if(collision):
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, cubeHeight, displacement.z)
		cubeHeight -= 0.1
func cubeCollision(body):
	bulletHitting(body)
	$AnimationPlayer.play("cubeExplode")
	collision = false

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "cubeExplode"):
		queue_free()
func sphereLogic(delta):
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -100 * delta
		global_transform.origin += displacement
func sphereCollision(body):
	bulletHitting(body)
	if !getFixedBoy:
		basis *=-1

func bulletHitting(body):
	if SignalsTrain.has_signal("bulletHit"):
		SignalsTrain.emit_signal("bulletHit", damage, body)
		
func amebaLogic(delta):
	if !onFloor:
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, cubeHeight, displacement.z)
		cubeHeight -= 0.1

func cylinderLogic(delta):
	if !onFloor:
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, cubeHeight, displacement.z)
		cubeHeight -= 0.1
	else:
		$AnimationPlayer.play("cylinderBullet")
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -20 * delta
		global_transform.origin += displacement

func pyramidCollision(body):
	bulletHitting(body)

func _on_braco_cilindro_body_entered(body):
	bulletHitting(body)
	if(body.name == "Ground"):
		print("jajaja")
		onFloor = true
		$cylinderDespawn.start()


func _on_brazo_ameba_body_entered(body):
	bulletHitting(body)
	if(body.name == "Ground"&&!getFixedBoy):
		onFloor = true
		print("fuck")
		$amebaDespawn.start()
