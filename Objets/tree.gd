extends Node3D

func _ready():
	$"tree-model".rotate_y(randi_range(0,360))
