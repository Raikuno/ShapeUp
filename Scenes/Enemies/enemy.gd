extends CharacterBody3D

signal hit(damageAmount)
@export var minSpeed = 5
@export var maxSpeed = 5
@export var Hp = 5
@export var Damage = 5
var skinNumber = randi_range(1,2)
var speed 
var hitting = false
var wandering = false
var wanderingPosition
var x_range = Vector2(-1500, 1500)  # Rango en el eje X
var z_range = Vector2(-1500, 1500)  # Rango en el eje Z

var signalBus
@onready var wanderingTimer = $Wandering
@onready var player = get_node("../player")


# HAY UN PROBLEMA CON LA PERCEPCIÓN DE LA VELOCIDAD, SI HACEMOS QUE EL PERSONAJE PUEDA ESCALAR EN VELOCIDAD INFINITAMENTE Y LOS ENEMIGOS NO ESCALAN NUNCA EN VELOCIDAD EL JUGADOR PODRÍA LITERALMENTE ESQUIVAR INFINITAMENTE A LOS ENEMIGOS Y ROMPER EL JUEGO
func _ready():

	var animation = $Animation/AnimationPlayer
	speed = randi_range(minSpeed, maxSpeed)
	if skinNumber == 2:
		animation.play("Animation2")
	


func _physics_process(_delta):
	if(hitting):
		if SignalsTrain.has_signal("hit"):
			SignalsTrain.emit_signal("hit", Damage)
	var transform = get_transform()
	transform.origin.y = 1.3
	set_transform(transform)
	#in wondering state the enemy move to random directions
	if wandering:
		if wanderingTimer.is_stopped():
			wanderingTimer.start()
		look_at_from_position(position, wanderingPosition, Vector3.UP)
	else:
		look_at_from_position(position, player.global_position, Vector3.UP)
		# random posibility to change the state to wandering
		if randi_range(1,2000) == 1:
			wanderingPosition = Vector3(randi_range(x_range.x, x_range.y), position.y,randi_range(z_range.x, z_range.y))

			print("bicho vagando")
			wandering = true
		
	# Se mueve palante
	velocity = Vector3.FORWARD * speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
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
	

func _on_vagando_timeout():
	wandering = false


func _on_area_3d_body_entered(body):
	if(body == player):
		hitting = true


# TE AMO SEÑOR https://www.youtube.com/watch?v=OUkbwOq9mBQ


func _on_area_3d_body_exited(body):
	hitting = false
