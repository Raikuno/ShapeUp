extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
var type
@onready var collision = true
@export var fall_acceleration = 75
@export var jump_impulse = 20
@onready var cubeHeight = 0.8
func _ready():
	pass
func _process(delta):
	pass
func callBullet():
		match type:
			CUBE:
				$brazoCubo.show()
				$AnimationPlayer.play("cube")
			PYRAMID:
				$brazoTriangulo.show()
				$AnimationPlayer.play("pyramid")
				remove_child($brazoCubo)
				remove_child($brazoEsfera)
				remove_child($brazoAmeba)
			SPHERE:
				$brazoEsfera.show()
			CYLINDER:
				pass
			AMEBA:
				$brazoAmeba.show()
				$AnimationPlayer.play("ameba")

func initialize(newType, direction, newPosition = position, newRotation = rotation):
	position = newPosition
	rotation = newRotation
	type = newType
	basis = direction
	callBullet()
func _physics_process(delta):
	match type:
		SPHERE:
			pass
		CYLINDER:
			pass
		CUBE:
			cubeLogic(delta)
		PYRAMID:
			pyramidLogic(delta)
		AMEBA:
			pass
func _on_visible_on_screen_notifier_3d_screen_exited():
	$outOfBounds.start()
func _on_outOfBounds_timeout():
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
		if true:
			cubeHeight -= 0.1
func cubeCollision(body):
	$AnimationPlayer.play("cubeExplode")
	collision = false
func _on_animation_player_animation_finished(anim_name):
	if(anim_name == "cubeExplode"):
		queue_free()
func sphereLogic(delta):
		var direction = global_transform.basis.z.normalized()
		var displacement : Vector3 = direction * -70 * delta
		global_transform.origin += displacement
func sphereCollision(body):
	basis *=-1

func _on_brazo_triangulo_body_entered(body):
	print("algo anda mal")
