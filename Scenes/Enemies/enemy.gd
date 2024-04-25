extends CharacterBody3D

@export var minSpeed = 5
@export var maxSpeed = 5
@export var Hp = 5
@export var Damage = 5
var skinNumber = randi_range(1,2)

func _ready():
	var animation = $Animation/AnimationPlayer
	if skinNumber == 2:
		animation.play("Animation2")

func _physics_process(_delta):
	move_and_slide()

	
func initialize(start_position, player_position):
	# We position the mob by placing it at start_position
	# and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	
	if skinNumber == 2:
		var skinChange = get_node("pivot").get_child(1)
		var skinOld = get_node("pivot").get_child(0)
		skinOld.hide()
		skinChange.show()
	# Rotate this mob randomly within range of -90 and +90 degrees,
	# We calculate a random speed (integer)
	var random_speed = randi_range(minSpeed, maxSpeed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
