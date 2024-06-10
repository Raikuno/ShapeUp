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
	scores = (await FirebaseLite.RealtimeDatabase.read("/"))
	print(scores)
	if scores[0] != 0:
		$TextureRect/Placement.text = "No se puede calcular tu \n posición global"
	else: 
		if scores[1]!=null:
			sortedScores = Score.orderScores(scores[1])
			calculatePosition()
		else: 
			placement = 1
		$TextureRect/Placement.text = $TextureRect/Placement.text.replace("X", str(placement))
	$TextureRect/Kills.text = "Bajas: " + str(Score.kills)
	$TextureRect/Time.text = "Tiempo: " + str(Score.time)
	$TextureRect/ScoreNum.text = str(Score.score)
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
			a = await FirebaseLite.RealtimeDatabase.write(asignedID, {"name" : $TextureRect/NameInput.text, "score": Score.score, "kills":Score.kills, "time":Score.time, "character":Score.characterToString()})
			if a[0] != 0:
				$notification.title = "Ups!"
				$notification.dialog_text = "A ocurrido un error. Revisa tu conexión"
				$notification.show()
			else:
				$notification.title = "Hecho!"
				$notification.dialog_text = "Tu puntuación se ha subid con éxito!"
				$notification.show()
				idiotPrevention = true
		elif !$TextureRect/NameInput.text == "" && len($TextureRect/NameInput.text) > MAXCHAR:
			$warning.dialog_text = "Tu nombre no puede tener más de" + str(MAXCHAR) +" carácteres!"
			$warning.show()
		else:
			$warning.dialog_text = "Necesitas un nombre para subir tu puntuación!"
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
