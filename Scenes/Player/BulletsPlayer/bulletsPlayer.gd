extends Node3D

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}

var type
var direction
func _ready():

	#position.x = $player_bienHecho/player/pivot.position.x
	#position.y = $player_bienHecho/player/pivot/rightArm.position.y
	#position.z = $player_bienHecho/player/pivot/rightArm.position.z
	#rotation.x = $player_bienHecho.rotation.x
	#rotation.y = $player_bienHecho.rotation.y
	#rotation.z = $player_bienHecho.rotation.z
	#scale.x = $player_bienHecho.scale.x
	#scale.y = $player_bienHecho.scale.y
	#scale.z = $player_bienHecho.scale.z
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
				$"brazoAmeba".show()
				$AnimationPlayer.play("ameba")

func initialize(newType, direction, newPosition = position, newRotation = rotation):
	position = newPosition
	rotation = newRotation
	type = newType
	basis = direction
	print(direction)
	callBullet()
func _physics_process(delta):
	var direction = global_transform.basis.z.normalized()
	# Calcular el desplazamiento
	var displacement : Vector3 = direction * -50 * delta

	# Mover el objeto
	global_transform.origin += displacement

func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.

func _on_visible_on_screen_notifier_3d_screen_exited():
	$pyramidTimer.start()

func _on_pyramid_timer_timeout():
	queue_free()
