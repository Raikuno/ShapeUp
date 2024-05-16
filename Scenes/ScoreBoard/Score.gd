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
	
func generateID():
	var alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
	var result = ""
	for i in range(0,10):
		result += alphabet[randi_range(0, len(alphabet) - 1)]
	result += str(randi())
	print(result)
	return result
	
func orderScores(map: Dictionary):
	var tempArray : Array
	for value in map:
		tempArray.append({"name" : map[value]["name"], "score" : map[value]["score"], "id" : value})
	tempArray.sort_custom(customComparison)
	return tempArray
	
func customComparison(a, b):
	if a["score"]==b["score"]:
		if a["name"] == b["name"]:
			return a["name"] == b["name"]
		else:
			return a["name"] > b["name"]
	else:
		return a["score"] > b["score"]
