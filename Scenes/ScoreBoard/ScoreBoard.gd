extends Node
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
var scores
var asignedID
var sortedScores
var placement = 1
func _ready():
	asignedID = Score.generateID()
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = await FirebaseLite.RealtimeDatabase.read("/scores/")
	sortedScores = Score.orderScores(scores[1])
	$TextureRect/Kills.text = "Figures executed: " + str(Score.kills)
	$TextureRect/Time.text = "Time Survived: " + str(Score.time)
	$TextureRect/Score.text = "Total Score: " + str(Score.score)
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibility(Score.character)
	calculatePosition()
	$TextureRect/Placement.text = $TextureRect/Placement.text.replace("X", str(placement))
	$TextureRect/Placement.show()
func calculatePosition():
	for entry in sortedScores:
		if Score.score < entry["score"]:
			placement += 1
		else:
			break

func upload():
	#NECESITAMOS VER LO QUE PASA SI NO HAY CONEXION. EN TEORIA a SERÁ UN ERROR Y HABRÁ QUE CONTROLARLO
	if scores != null:
		var a
		var sortedScores = Score.orderScores(scores[1])
		if !$TextureRect/NameInput.text == "":
			a = await FirebaseLite.RealtimeDatabase.write("scores/" + asignedID, {"name" : $TextureRect/NameInput.text, "score": Score.score, "character":Score.characterToString()})
			print(a)
			$notification.title = "Done!"
			$notification.dialog_text = "Your score have been uploaded successfully!"
			$notification.show()
		else:
			$warning.show()

func back():
	Score.reset()
	RoomManager.changeRoom(MAINMENU)
	queue_free()
