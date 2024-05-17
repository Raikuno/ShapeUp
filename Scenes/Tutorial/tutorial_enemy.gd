extends CharacterBody3D

signal hit(damageAmount)
@export var minSpeed = 5
@export var maxSpeed = 5
@export var Hp = 5
@export var Damage = 5
var speed 
var hitting = false
var golpes = 0
var omaewamoshindeiru = false
var enemyType #1 = cilindro / 2 = cubo / 3 = esfera / 4 = peakamide
var x_range = Vector2(-1500, 1500)  # Rango en el eje X
var z_range = Vector2(-1500, 1500)  # Rango en el eje Z

var experience : PackedScene
var signalBus
@onready var wanderingTimer = $Wandering
@onready var player = get_node("../player")


# HAY UN PROBLEMA CON LA PERCEPCIÓN DE LA VELOCIDAD, SI HACEMOS QUE EL PERSONAJE PUEDA ESCALAR EN VELOCIDAD INFINITAMENTE Y LOS ENEMIGOS NO ESCALAN NUNCA EN VELOCIDAD EL JUGADOR PODRÍA LITERALMENTE ESQUIVAR INFINITAMENTE A LOS ENEMIGOS Y ROMPER EL JUEGO
func _ready():
	var animation = $Animation/AnimationPlayer
	
	speed = randi_range(minSpeed, maxSpeed)
	SignalsTrain.bulletHit.connect(onDamageTaken)

	
func onDamageTaken(damageAmount, body):
	if body == self:
		$GPUParticles3D.restart()
		Hp -= damageAmount
		if(Hp <= 0):
			enemyDeath()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "DondeCaemosGente":
		$Animation.get_child(0).play("Animation1")
		
	if anim_name == "DeathAnimation":
		Score.kills +=1
		queue_free()


func enemyDeath():
	if !omaewamoshindeiru:
		if SignalsTrain.has_signal("sumarKills"):
			SignalsTrain.emit_signal("sumarKills")
		if SignalsTrain.has_signal("isTutorialEnemy"):
			SignalsTrain.emit_signal("isTutorialEnemy")
		omaewamoshindeiru = true
		var position = global_transform.origin
		var experience = load("res://Scenes/Experience/experience.tscn")
		var experienceObject = experience.instantiate()
		experienceObject.initialize(position, enemyType)
		add_sibling(experienceObject)
		$Animation.get_child(0).play("DeathAnimation")
	
func _physics_process(_delta):
	var transform = get_transform()
	transform.origin.y = 1.3
	set_transform(transform)

	look_at_from_position(position, player.global_position, Vector3.UP)
		# Se mueve palante
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide()

func multiplyStats(statsMultiplier):
	minSpeed = minSpeed + (0.1 * minSpeed * statsMultiplier)
	maxSpeed = maxSpeed + (0.1 * maxSpeed * statsMultiplier)
	Hp = Hp + (0.5 * Hp * statsMultiplier)
	Damage = Damage + (0.5 * Damage * statsMultiplier)
	

func initialize(start_position, player_position, _enemyType, statsMultiplier):
	enemyType = _enemyType
	look_at_from_position(start_position, player_position, Vector3.UP)
	multiplyStats(statsMultiplier)

func _on_area_3d_body_entered(body):
	if(body == player):
		hitting = true

func _on_area_3d_body_exited(body):
	hitting = false


func _on_hitting_timeout():
	if(hitting && golpes <= 27):
		golpes += 1
		if SignalsTrain.has_signal("hit"):
			SignalsTrain.emit_signal("hit", Damage)

