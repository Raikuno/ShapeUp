extends Node
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
var scores
var asignedID
var sortedScores
var placement = 1
var idiotPrevention = false
func _ready():
	setTexts()
	asignedID = Score.generateID()
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = (await FirebaseLite.RealtimeDatabase.read("/"))
	print(scores)
	if scores[0] != 0:
		$TextureRect/Placement.text = tr("POSITION_ERROR")
	else: 
		if scores[1]!=null:
			sortedScores = Score.orderScores(scores[1])
			calculatePosition()
		else: 
			placement = 1
		$TextureRect/Placement.text = tr("POSITION").format({"position":str(placement)})
	$TextureRect/Kills.text = tr("SCORELIST_KILLS") + str(Score.kills)
	$TextureRect/Time.text = tr("SCORELIST_TIME") + str(Score.time)
	$TextureRect/Score.text = tr("SCORE")
	$TextureRect/ScoreNum.text = str(Score.score)
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibility(Score.character)
	$TextureRect/Score.show()
	$TextureRect/Placement.show()
func calculatePosition():
	for entry in sortedScores:
		if Score.score < entry["score"]:
			placement += 1
		else:
			break

func setTexts():
	$TextureRect/Upload.text = tr("UPLOAD")
	$TextureRect/Back.text = tr("SCORELIST_EXIT")
	$TextureRect/Name.text = tr("NAME")
	$IdiotPrevention.title = tr("SCORE_UPLOAD_TITLE")
	$IdiotPrevention.dialog_text = tr("WARNING_EXIT")

func upload():
	const MAXCHAR = 20
	#NECESITAMOS VER LO QUE PASA SI NO HAY CONEXION. EN TEORIA a SERÁ UN ERROR Y HABRÁ QUE CONTROLARLO
	if scores != null:
		var a
		if !$TextureRect/NameInput.text == "" && len($TextureRect/NameInput.text) < MAXCHAR:
			a = await FirebaseLite.RealtimeDatabase.write(asignedID, {"name" : $TextureRect/NameInput.text, "score": Score.score, "kills":Score.kills, "time":Score.time, "character":Score.characterToString()})
			if a[0] != 0:
				$notification.title = "Ups!"
				$notification.dialog_text = tr("SCORE_ERROR")
				$notification.show()
			else:
				$notification.title = tr("SCORE_UPLOAD_TITLE")
				$notification.dialog_text = tr("SCORE_UPLOAD")
				$notification.show()
				idiotPrevention = true
		elif !$TextureRect/NameInput.text == "" && len($TextureRect/NameInput.text) > MAXCHAR:
			$warning.title = tr("SCORE_UPLOAD_TITLE")
			$warning.dialog_text = tr("NAME_ERROR").format({"characters":str(MAXCHAR)})
			$warning.show()
		else:
			$warning.title = tr("SCORE_UPLOAD_TITLE")
			$warning.dialog_text = tr("WARNING_NAME")
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
