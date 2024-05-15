extends Node
const MAINMENU = "res://Scenes/Main/mainPPK.tscn"
var scores
# Called when the node enters the scene tree for the first time.
func _ready():
	FirebaseLite.initializeFirebase(["Authentication", "Realtime Database"])
	FirebaseLite.Authentication.initializeAuth(1)
	scores = await FirebaseLite.RealtimeDatabase.read("/scores/")
	$TextureRect/Kills.text = "Figures executed: " + str(Score.kills)
	$TextureRect/Time.text = "Time Survived: " + str(Score.time)
	$TextureRect/Score.text = "Total Score: " + str(Score.score)
	$TextureRect/SubViewportContainer/SubViewport/playerPreview.changeVisibility()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func upload(): #jorge si lees esto que sepas que te odio
	# Para evitar la repetición de nombres concatenas el nombre del player más un numero random de uno a 10000 por ejemplo ~~ PPK15824 ~~
	if scores != null:
		var slot : String
		slot = "Player" + str(len(scores[1]))
		if !$TextureRect/NameInput.text == "":
			FirebaseLite.RealtimeDatabase.write("scores/" + slot, {"name" : $TextureRect/NameInput.text, "score": Score.score, "character":Score.character})
		else:
			$ConfirmationDialog.show()

func back():
	Score.reset()
	RoomManager.changeRoom(MAINMENU)
	queue_free()
