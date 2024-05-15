extends Node

enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}#Quiza podriamos aprovechar que esto hay que cargarlo aqui y hacerlo global (Semana 6)
const SECONDSPOINTS = 10
const KILLSPOINTS = 600
var time : String
var kills : int = 0
var score : int 
var character = {}
var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
func setScore():
	var timeNumbers = time.split(":")
	score = (kills * KILLSPOINTS) + (int(timeNumbers[0]) * SECONDSPOINTS * 60) + (int(timeNumbers[1]) * SECONDSPOINTS)
func saveCharacter(head, body, right, left, feet):
	character = {
		"head" : head,
		"body" : body,
		"right" : right,
		"left" : left,
		"feet" : feet
	}
func reset():
	time = ""
	kills = 0
	score = 0
	character = {}

