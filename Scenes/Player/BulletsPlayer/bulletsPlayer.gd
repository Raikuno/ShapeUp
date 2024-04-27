extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}

var type
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func callBullet():
		match type:
			CUBE:
				pass
			PYRAMID:
				$brazoTriangulo.show()
				$AnimationPlayer.play("pyramid")
			SPHERE:
				pass
			CYLINDER:
				pass
			AMEBA:
				pass

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
			pass
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
