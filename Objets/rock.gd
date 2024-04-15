extends Node3D

func _ready():
	$".".rotate_y(randi_range(0,360))
