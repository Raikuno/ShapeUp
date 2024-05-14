extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.text = "Figures executed: " + str(Score.kills)
	$Time.text = "Time Survived: " + str(Score.time)
	$Score.text = "Total Score: " + str(Score.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
