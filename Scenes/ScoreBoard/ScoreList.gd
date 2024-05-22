extends Node
enum {CUBE, PYRAMID, SPHERE, CYLINDER, AMEBA}
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
@onready var playerList = $TextureRect/ItemList
var scores
var sortedScores
var playerCharacter
var playerScore
var playerName
var playerTime
var playerKills
func _ready():
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = await FirebaseLite.RealtimeDatabase.read("/")
	print(scores[1])
	if scores[0] == 0:
		sortedScores = Score.orderScores(scores[1])
		print("MORBIUS")
		giveListValue()
		
	else:
		$TextureRect/Score.text = "Can't connect to the database"

func giveListValue():
	var position = 1
	print(sortedScores)
	for item in sortedScores:
		print(item["name"])
		playerList.add_item(str(position) + "º " + item["name"])
		position +=1

func setInfo():
	$TextureRect/Score.text = "Score: " + str(playerScore)
	$TextureRect/Name.text = "Name: " + playerName
	$TextureRect/Time.text = "Time: " + playerTime
	$TextureRect/Kills.text = $TextureRect/Kills.text.replace("X", str(playerKills))
	$TextureRect/Time.show()
	$TextureRect/Kills.show()
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.resetVisibility()
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibilityString(playerCharacter)

func back():
	RoomManager.changeRoom(MAINMENU)
	queue_free()


func _on_item_list_item_selected(index):
	var id = sortedScores[index]["id"]
	playerCharacter = scores[1][id]["character"]
	playerName = scores[1][id]["name"]
	playerScore = scores[1][id]["score"]
	playerTime = scores[1][id]["time"]
	playerKills = scores[1][id]["kills"]
	setInfo()
