extends Node3D

var explanationNumber = 0
var canPressTheButton = false
var expPicked = false
var expAmount = -1
@onready var explanationText = $Control/ExplanationText
@onready var circle = $Control/LittleCircle
@onready var reallyLittlecircle = $Control/ReallyLittleCircle
@onready var effectsTimer = $effects
@onready var tryYourselfTimer = $tryYourself
const MENU = "res://Scenes/Main/mainPPK.tscn"
var explanationTexts = [
	tr("TUTORIAL_MSG1"), 
	tr("TUTORIAL_MSG2"), 
	tr("TUTORIAL_MSG3"), 
	tr("TUTORIAL_MSG4"),
	tr("TUTORIAL_MSG5"),
	tr("TUTORIAL_MSG6"),
	tr("TUTORIAL_MSG7"),
	tr("TUTORIAL_MSG8"), #9
	tr("TUTORIAL_MSG9"),
	tr("TUTORIAL_MSG10"),
	tr("TUTORIAL_MSG11"),
	tr("TUTORIAL_MSG12"),
	tr("TUTORIAL_MSG13"),
	tr("TUTORIAL_MSG14"),
	tr("TUTORIAL_MSG15"),
	tr("TUTORIAL_MSG16"),
	"",
	tr("TUTORIAL_MSG18"),
	tr("TUTORIAL_MSG19"),
	tr("TUTORIAL_MSG20"),
	tr("TUTORIAL_MSG21"),
	tr("TUTORIAL_MSG22"),
	tr("TUTORIAL_MSG23"),
	tr("TUTORIAL_MSG24"),
	tr("TUTORIAL_MSG25"),
	tr("TUTORIAL_MSG26"),
	tr("TUTORIAL_MSG27"),
	""]
	
var positionTexts = [
	Vector2(-374,-232),
	Vector2(-374,-232),
	Vector2(-374,-232),
	Vector2(-374,-232),
	Vector2(-385,92), #4
	Vector2(-436,-110),
	Vector2(-557,-57),
	Vector2(-374,-232),
	Vector2(-374,-232),
	Vector2(-490,-232), #9
	Vector2(-450,-232),
	Vector2(-450,-232), 
	Vector2(-450,-232), 
	Vector2(-445,92),   #13
	Vector2(-450,-202),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-400,150), #18
	Vector2(-387,110),
	Vector2(-387,110),
	Vector2(-387,110),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	Vector2(-450,-232),
	]
func _ready():
	$Control/Salir.text = tr("TUTORIAL_EXIT")
	$Control/Next.text = tr("TUTORIAL_CONTINUE")
	SignalsTrain.isTutorialEnemy.connect(onTutorialEnemyDeath)
	SignalsTrain.isTutorialExperience.connect(onTutorialExperiencePicked)
	get_tree().paused = true
	circle.position = Vector2(-5126, -4028)
	reallyLittlecircle.position = Vector2(-1826, -1674)
	circle.show()
	reallyLittlecircle.hide()
	canPressTheButton = true
	#$efectos.start()	
	explanationText.text = explanationTexts[explanationNumber]
	explanationText.position = positionTexts[explanationNumber]


func _on_efectos_timeout():
	match explanationNumber:
		0: 
			canPressTheButton = true
			effectsTimer.stop()
		1: 
			canPressTheButton = true
			effectsTimer.stop()
		2: 
			canPressTheButton = true
			effectsTimer.stop()
		3:
			canPressTheButton = true
			effectsTimer.stop()
		4: 
			moveCircle(circle, 25, -4001, -4018, false, false)
			if circle.position.x >= -4001:
				canPressTheButton = true
				effectsTimer.stop()
		5:
			moveCircle(circle, 20, -4362, -4183, true, true)
			if circle.position.x <= -4362 && circle.position.y <= -4183 :
				canPressTheButton = true
				effectsTimer.stop()
		6:
			moveCircle(reallyLittlecircle, 5, -1967, -1596, true, false)
			if reallyLittlecircle.position.x <= -1967 && reallyLittlecircle.position.y >= -1596 :
				canPressTheButton = true	
				effectsTimer.stop()
		7:
			moveCircle(reallyLittlecircle, 10, -1486, -1760, false, true)
			if reallyLittlecircle.position.x >= -1486 && reallyLittlecircle.position.y <= -1760 :
				canPressTheButton = true	
				effectsTimer.stop()
		8:
			canPressTheButton = true
			effectsTimer.stop()
		9:
			canPressTheButton = true
			effectsTimer.stop()	
		10:
			canPressTheButton = true
			effectsTimer.stop()	
		11:
			canPressTheButton = true
			effectsTimer.stop()	
		12:
			canPressTheButton = true
			effectsTimer.stop()
		13:
			moveCircle(circle, 25, -4001, -4018, true, false)
			if circle.position.x <= -4001 && circle.position.y >= -4018:
				canPressTheButton = true
				effectsTimer.stop()
		14:
			canPressTheButton = true
			effectsTimer.stop()	
		15:
			canPressTheButton = true
			effectsTimer.stop()	
		16:
			canPressTheButton = true
			effectsTimer.stop()	
		17:
			canPressTheButton = true
			effectsTimer.stop()	
		18:
			moveCircle(circle, 25, -4473, -3843, true, true)
			if circle.position.x <= -4473 && circle.position.y <= -3843:
				canPressTheButton = true
				effectsTimer.stop()
		19:
			canPressTheButton = true
			effectsTimer.stop()	
		20:
			moveCircle(circle, 10, -4000, -4009, false, true)
			if circle.position.x >= -4000 && circle.position.y <= -4009:
				canPressTheButton = true	
				effectsTimer.stop()
		21:
			canPressTheButton = true
			effectsTimer.stop()	
		22:
			moveCircle(circle, 10, -3508, -4197, false, true)
			if circle.position.x >= -3508 && circle.position.y <= -4197:
				canPressTheButton = true	
				effectsTimer.stop()
		23:
			canPressTheButton = true
			effectsTimer.stop()	
		24:
			canPressTheButton = true
			effectsTimer.stop()	
		25:
			canPressTheButton = true
			effectsTimer.stop()		
		26:
			canPressTheButton = true
			effectsTimer.stop()		
func moveCircle(theCircle, speed , positionX, positionY, isXHigher, isYHigher):  
	#de derecha a izquierda es true, de abajo a arriba es true
	if isXHigher && isYHigher: #3000 < 2000
		if theCircle.position.x > positionX && theCircle.position.y > positionY: #-5000 < -4000
			theCircle.position = Vector2(theCircle.position.x - speed,theCircle.position.y - speed)
		elif  theCircle.position.x > positionX:
			theCircle.position = Vector2(theCircle.position.x - speed ,theCircle.position.y)	
		elif theCircle.position.y > positionY:
			theCircle.position = Vector2(theCircle.position.x ,theCircle.position.y - speed)	
	elif isXHigher:  #3000 < 2000
		if theCircle.position.x > positionX && theCircle.position.y < positionY: #-5000 < -4000
			theCircle.position = Vector2(theCircle.position.x - speed,theCircle.position.y + speed)
		elif  theCircle.position.x > positionX:
			theCircle.position = Vector2(theCircle.position.x - speed ,theCircle.position.y)	
		elif theCircle.position.y < positionY:
			theCircle.position = Vector2(theCircle.position.x ,theCircle.position.y + speed)	
	elif isYHigher: 
		if theCircle.position.x < positionX && theCircle.position.y > positionY: #-5000 < -4000
			theCircle.position = Vector2(theCircle.position.x + speed,theCircle.position.y - speed)
		elif  theCircle.position.x < positionX:
			theCircle.position = Vector2(theCircle.position.x + speed ,theCircle.position.y)	
		elif theCircle.position.y > positionY:
			theCircle.position = Vector2(theCircle.position.x ,theCircle.position.y - speed)	
	else:
		if theCircle.position.x < positionX && theCircle.position.y < positionY: #-5000 < -4000
			theCircle.position = Vector2(theCircle.position.x + speed,theCircle.position.y + speed)
		elif  theCircle.position.x < positionX:
			theCircle.position = Vector2(theCircle.position.x + speed ,theCircle.position.y)	
		elif theCircle.position.y < positionY:
			theCircle.position = Vector2(theCircle.position.x ,theCircle.position.y + speed)	
			
func _on_next_pressed():
	print(canPressTheButton," :",  explanationNumber)
	if canPressTheButton:
		canPressTheButton = false
		explanationNumber += 1
		explanationText.text = explanationTexts[explanationNumber]
		explanationText.position = positionTexts[explanationNumber]
		effectsTimer.start()	
		match explanationNumber:
			6:
				circle.hide()
				reallyLittlecircle.show()
			8:
				circle.show()
				reallyLittlecircle.hide()
				circle.position = Vector2(-3990,-4784)
			
			10:
				circle.hide()
				get_tree().paused = false
				tryYourselfTimer.start()
				$Control/Next.hide()
				explanationText.hide()
			11:
				get_tree().paused = false
				$Control/Next.hide()
				explanationText.hide()
			
			12:
				get_tree().paused = false
				$Control/Next.hide()
				explanationText.hide()
				if SignalsTrain.has_signal("isTutorialExperienceEnable"):
					SignalsTrain.emit_signal("isTutorialExperienceEnable")
			13:
				circle.show()
			14: 
				circle.hide()
				circle.position = Vector2(-3910,-3384)
			15:
				explanationText.hide()
				$Control/Next.hide()
				get_tree().paused = false
				$MainTutorial.onPlayerSelectPart()
			16:
				get_tree().paused = false
				$MainTutorial._onExpSpawn()
				$Control/Next.hide()
				circle.hide()
			17:
				circle.show()
				circle.position = Vector2(-4102,-3410)
			19:
				reallyLittlecircle = Vector2(-1972,-1318)
			24:
				circle.hide()
			27:
				get_tree().paused = false
				get_tree().change_scene_to_file(MENU)

func _on_try_yourself_timeout():
	get_tree().paused = true
	canPressTheButton = true
	explanationText.show()
	$Control/Next.show()
	tryYourselfTimer.stop()

func onTutorialEnemyDeath():
	tryYourselfTimer.start(0.5)

func onTutorialExperiencePicked():
	print(expPicked, "  ", expAmount)
	if expPicked:
		if expAmount == -1:
			circle.show()
			tryYourselfTimer.start(0.5)
		expAmount += 1
		if expAmount == 8:
			circle.show()
			tryYourselfTimer.start(0.5)
	else:
		circle.show()
		tryYourselfTimer.start(0.5)

	expPicked = true
	
func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU)
