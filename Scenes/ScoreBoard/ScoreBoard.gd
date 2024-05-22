extends Node
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
var scores
var asignedID
var sortedScores
var placement = 1
var idiotPrevention = false
func _ready():
	asignedID = Score.generateID()
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = (await FirebaseLite.RealtimeDatabase.read("/scores/"))
	if scores[0] != 0:
		$TextureRect/Placement.text = "Couldn't calculate your \n global position"
	else: 
		sortedScores = Score.orderScores(scores[1])
		calculatePosition()
		$TextureRect/Placement.text = $TextureRect/Placement.text.replace("X", str(placement))
	$TextureRect/Kills.text = "Figures executed: " + str(Score.kills)
	$TextureRect/Time.text = "Time Survived: " + str(Score.time)
	$TextureRect/Score.text = "Total Score: " + str(Score.score)
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibility(Score.character)
	$TextureRect/Placement.show()
func calculatePosition():
	for entry in sortedScores:
		if Score.score < entry["score"]:
			placement += 1
		else:
			break

func upload():
	const MAXCHAR = 20
	#NECESITAMOS VER LO QUE PASA SI NO HAY CONEXION. EN TEORIA a SERÁ UN ERROR Y HABRÁ QUE CONTROLARLO
	if scores != null:
		var a
		if !$TextureRect/NameInput.text == "" && len($TextureRect/NameInput.text) < MAXCHAR:
			a = await FirebaseLite.RealtimeDatabase.write("scores/" + asignedID, {"name" : $TextureRect/NameInput.text, "score": Score.score, "character":Score.characterToString()})
			if a[0] != 0:
				$notification.title = "Ups!"
				$notification.dialog_text = "There was an error uploading your score. Check your conection"
				$notification.show()
			else:
				$notification.title = "Done!"
				$notification.dialog_text = "Your score have been uploaded successfully!"
				$notification.show()
				idiotPrevention = true
		elif !$TextureRect/NameInput.text == "" && len($TextureRect/NameInput.text) > MAXCHAR:
			$warning.dialog_text = "Your name cant have more than" + str(MAXCHAR) +" characters!"
			$warning.show()
		else:
			$warning.dialog_text = "You cant submit your score without a name!"
			$warning.show()

func back():
	if idiotPrevention:
		exit()
	else:
		$IdiotPrevention.show()


func exit():
	Score.reset()
	RoomManager.changeRoom(MAINMENU)
	queue_free()
