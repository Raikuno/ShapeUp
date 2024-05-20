extends CharacterBody3D

signal hit(damageAmount)
@export var minSpeed = 5
@export var maxSpeed = 5
@export var Hp = 5
@export var Damage = 5
var skinNumber = randi_range(1,2)
var speed 
var hitting = false
var omaewamoshindeiru = false
var wanderingValue = 0
var wanderingTime = 0
var wandering = false
var isBoss = false
var wanderingPosition
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
	getWanderingValue()
	

func getWanderingValue():
	match enemyType:
		1:
			wanderingValue = 180
			wanderingTime = 12
		2:
			wanderingValue = 1050
			wanderingTime = 2
		3:
			wanderingValue = 140
			wanderingTime = 10
		4:
			wanderingValue = 850
			wanderingTime = 3

func onBossSpawn():
	isBoss = true
	scale = Vector3(3,3,3)
	
func onDamageTaken(damageAmount, body):
	if body == self:
		$GPUParticles3D.restart()
		Hp -= damageAmount
		if(Hp <= 0):
			enemyDeath()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "DondeCaemosGente":
		if skinNumber == 1:
			$Animation.get_child(0).play("Animation1")
		else:
			$Animation.get_child(0).play("Animation2")
	if skinNumber == 1:
		if anim_name == "DeathAnimation":
			Score.kills +=1
			queue_free()
	else:
		if anim_name == "DeathAnimation2":
			Score.kills +=1
			queue_free()
	

func enemyDeath():
	if !omaewamoshindeiru:
		if isBoss:
			for i in 5:
				SignalsTrain.emit_signal("sumarKills")
				expSpawn(position + Vector3(i,i,i))
		else:
			SignalsTrain.emit_signal("sumarKills")
			expSpawn(position)
		omaewamoshindeiru = true
		if skinNumber == 1:
			$Animation.get_child(0).play("DeathAnimation")
		else:
			$Animation.get_child(0).play("DeathAnimation2")

func expSpawn(expPosition):
	var position = global_transform.origin
	var experience = load("res://Scenes/Experience/experience.tscn")
	var experienceObject = experience.instantiate()
	experienceObject.initialize(expPosition, enemyType)
	add_sibling(experienceObject)
		
func _physics_process(_delta):
	var transform = get_transform()
	transform.origin.y = 1.3
	set_transform(transform)
	#in wondering state the enemy move to random directions
	if !isBoss && wandering:
		if wanderingTimer.is_stopped():
			wanderingTimer.start(randi_range(2,wanderingTime))
			look_at_from_position(position, wanderingPosition, Vector3.UP)
	else:
		look_at_from_position(position, player.global_position, Vector3.UP)
		# una probabilidad random de que el enemigo entre en estado wandering
		if !isBoss && randi_range(1,wanderingValue) == 1:
			wanderingPosition = Vector3(randi_range(x_range.x, x_range.y), position.y,randi_range(z_range.x, z_range.y))
			wandering = true
		
	# Se mueve palante
	velocity = Vector3.FORWARD * speed

	velocity = velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide()

func multiplyStats(statsMultiplier):
	minSpeed = minSpeed + (0.1 * minSpeed * statsMultiplier)
	maxSpeed = maxSpeed + (0.1 * maxSpeed * statsMultiplier)
	Hp = Hp + (0.3 * Hp * statsMultiplier)
	Damage = Damage + (0.2 * Damage * statsMultiplier)
	

func initialize(start_position, player_position, _enemyType, statsMultiplier):
	enemyType = _enemyType
	look_at_from_position(start_position, player_position, Vector3.UP)
	multiplyStats(statsMultiplier)
	if skinNumber == 2:
		var skinChange = get_node("pivot").get_child(1)
		var skinOld = get_node("pivot").get_child(0)
		skinOld.hide()
		skinChange.show()

func _on_vagando_timeout():
	wandering = false


func _on_area_3d_body_entered(body):
	if(body == player):
		hitting = true

func _on_area_3d_body_exited(body):
	hitting = false


func _on_hitting_timeout():
	if(hitting):
		if SignalsTrain.has_signal("hit"):
			SignalsTrain.emit_signal("hit", Damage)


func _on_expire_time_timeout():
	if !isBoss && !$VisibleOnScreenNotifier3D.is_on_screen():
		queue_free()
