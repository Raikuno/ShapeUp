extends Node
func changeRoom(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	var s = load(res_path)
	var current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
