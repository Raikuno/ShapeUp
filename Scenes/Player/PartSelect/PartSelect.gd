extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Obtén el nodo Viewport
	var viewport = $Viewport

	# Captura la textura del Viewport
	var texture = viewport.get_texture().get_data()

	# Crea un control TextureRect para mostrar la textura
	var texture_rect = TextureRect.new()
	texture_rect.texture = texture

	# Agrega el TextureRect a la jerarquía de nodos de la interfaz de usuario
	add_child(texture_rect)
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("jaja")
	if Input.is_action_just_pressed("debug"):
		get_tree().paused = false
		queue_free()
