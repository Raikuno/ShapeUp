extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var type
@onready var onFloor = false
@onready var collision = true
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var damage = 50   # cada tipo de brazo va a tener un multiplicador al daño base del jugador, por ejemplo circulo hará un 0.75 del daño base y cuadrado un 1.25
@onready var height = -4
var scaleModifiers
func _ready():
	pass
func _process(delta):
	pass
func callBullet(newScale):
	match type:
		CUBE:
			$brazoCubo.show()
			$"brazoCubo/brazo-cuboPlayer".scale = newScale + scaleModifiers
			remove_child($brazoTriangulo)
			remove_child($brazoEsfera)
			remove_child($brazoAmeba)
			remove_child($bracoCilindro)
		PYRAMID:
			$brazoTriangulo.show()
			$brazoTriangulo.scale = newScale + scaleModifiers
			remove_child($brazoCubo)
			remove_child($brazoEsfera)
			remove_child($brazoAmeba)
			remove_child($bracoCilindro)
		SPHERE:
			$brazoEsfera.show()
			$"brazoEsfera/brazo-esferaPlayer".scale = newScale + scaleModifiers
			remove_child($brazoCubo)
			remove_child($brazoTriangulo)
			remove_child($brazoAmeba)
			remove_child($bracoCilindro)
		CYLINDER:
			$bracoCilindro.show()
			$"bracoCilindro/brazo-cilindroPlayer".scale = newScale + scaleModifiers
			remove_child($bracoAmeba)
			remove_child($brazoCubo)
			remove_child($brazoTriangulo)
			remove_child($brazoSphere)
			remove_child($brazoAmeba/CollisionShape3D)
			
		AMEBA:
			$brazoAmeba.show()
			$brazoAmeba.scale = newScale + scaleModifiers
			remove_child($brazoCubo)
			remove_child($brazoTriangulo)
			remove_child($brazoSphere)
			remove_child($bracoCilindro)

func initialize(newType, newDamage, bulletDirection, scaleModifier,newPosition = position, newRotation = rotation, newScale = scale):
	var downer : float
	if newType == SPHERE:
		downer = 1.5
	else:
		downer = 1
	newPosition
	position = Vector3(newPosition.x, newPosition.y - downer, newPosition.z)
	rotation = newRotation
	scale = newScale
	scaleModifiers = Vector3(scaleModifier, scaleModifier, scaleModifier)
	type = newType
	damage = newDamage
	look_at(Vector3(bulletDirection.x, position.y, bulletDirection.z), Vector3.UP)
	callBullet(newScale)
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
	global_transform.origin += Vector3(displacement.x, 0, displacement.z)
func cubeLogic(delta):
	if(collision):
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, displacement.y + (height * delta), displacement.z)
func cubeCollision(body):
	bulletHitting(body)
	collision = false
	if $brazoCubo.visible and !$AudioStreamPlayer.playing: 
		$AnimationPlayer.play("cubeExplode")
		$AudioStreamPlayer.play()

func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "cubeExplode"):
		queue_free()
func sphereLogic(delta):
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -100 * delta
		global_transform.origin += Vector3(displacement.x, 0, displacement.z)
func sphereCollision(body):
	if $brazoEsfera.visible:
		bulletHitting(body)
		basis *=-1

func bulletHitting(body):
	if SignalsTrain.has_signal("bulletHit"):
		SignalsTrain.emit_signal("bulletHit", damage, body)
		
func amebaLogic(delta):
	if !onFloor:
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, displacement.y + (height * delta), displacement.z)

func cylinderLogic(delta):
	if !onFloor:
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += Vector3(displacement.x, displacement.y + (height * delta), displacement.z)
	else:
		$AnimationPlayer.play("cylinderBullet")
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -20 * delta
		global_transform.origin += Vector3(displacement.x, 0, displacement.z)

func pyramidCollision(body):
	if $brazoTriangulo.visible:
		bulletHitting(body)

func _on_braco_cilindro_body_entered(body):
	if $bracoCilindro.visible:
		bulletHitting(body)
		if((body.name == "Ground"||body.name == "rock"||body.name=="tree") and !onFloor):
			onFloor = true
			$cylinderDespawn.start()
			print($cylinderDespawn.is_stopped())

func _on_brazo_ameba_body_entered(body):
	if $brazoAmeba.visible:
		bulletHitting(body)
		if(body.name == "Ground"||body.name == "rock"||body.name=="tree"):
			onFloor = true
			$amebaDespawn.start()
