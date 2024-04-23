extends CharacterBody3D

@export var minSpeed = 5
@export var maxSpeed = 5

func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# We calculate a random speed (integer)
	var random_speed = randi_range(minSpeed, maxSpeed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
