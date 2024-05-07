extends Control

func _ready():
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("jaja")
	if Input.is_action_just_pressed("debug"):
		get_tree().paused = false
		queue_free()

func initialize(node, figure, part):
	var img = $TextureRect
	img.texture = node.get_texture()
