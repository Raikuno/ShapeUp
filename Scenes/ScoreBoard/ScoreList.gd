extends Node
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
@onready var playerList = $TextureRect/ItemList
var scores
var sortedScores
var playerCharacter
var playerScore
var playerName
func _ready():
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = (await FirebaseLite.RealtimeDatabase.read("/scores/"))[1]
	if scores == null:
		scores = {}
	print(scores)
	sortedScores = Score.orderScores(scores)
	giveListValue()

func giveListValue():
	var position = 1
	for item in sortedScores:
		playerList.add_item(str(position) + "º " + item["name"])
		position +=1

func setInfo():
	$TextureRect/Score.text = "Score: " + str(playerScore)
	$TextureRect/Name.text = "Name: " + playerName
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.resetVisibility()
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibilityString(playerCharacter)
	pass

func back():
	RoomManager.changeRoom(MAINMENU)
	queue_free()


func _on_item_list_item_selected(index):
	var id = sortedScores[index]["id"]
	print(id)
	print(scores[id])
	playerCharacter = scores[id]["character"]
	playerName = scores[id]["name"]
	playerScore = scores[id]["score"]
	setInfo()
