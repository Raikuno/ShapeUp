extends Node3D

var explanationNumber = 0
var canPressTheButton = false
@onready var explanationText = $Control/ExplanationText
@onready var circle = $Control/LittleCircle
@onready var reallyLittlecircle = $Control/ReallyLittleCircle
@onready var effectsTimer = $effects
@onready var tryYourselfTimer = $tryYourself
const MENU = "res://Scenes/Main/mainPPK.tscn"
var explanationTexts = [
	"Bienvenido a Shape Up! 
	(haz click en continuar)", 
	"Shape up es un juego en el que tendrás que sobrevivir
	a oleadas de enemigos el máximo tiempo posible", 
	"Para ello tendrás que acabar con tus enemigos y 
	obtener sus puntos de experiencia, los cuales te permitirán 
	hacerte más fuerte y por tanto, sobrevivir más tiempo.",
	"Observemos los elementos del juego!", 
	"Este eres tú, tendrás que moverte y 
	apuntar a los enemigos para derrotarlos",
	"Esta es tu barra de vida, si los enemigos te golpean bajará,
	si llega a cero acabará la partida.",
	"Este es el contador de bajas,
	aquí se registrarán los enemigos que derrotes.",
	"Este es el tiempo de juego, 
	¡intenta conseguir el máximo posible antes de perder!",
	"El tiempo de juego y las bajas que obtengas al terminar el juego
	será tu puntuación final, 
	¡intenta llegar a la cima de la clasificación mundial!", #9
	"Ahora veamos el movimiento, con WASD o las flechas direccionales podrás moverte,
	usa el ratón para que el personaje mire en esa dirección,
	verás que ataca automaticamente.",
	"¡Apareció un enemigo! Apunta bien y acaba con él!",
	"Los enemigos sueltan experiencia, hay 4 tipos de enemigos
	caracterizados por una forma y un color concreto,
	este enemigo soltó la experiencia del 'cubo', intenta cogerla ",
	"Bien hecho! conseguiste un punto de experiencia, 
	¡veamos para que sirve!",
	"El jugador se compone de 5 partes del cuerpo: 
	cabeza, cuerpo, brazo izquierdo, brazo derecho y piernas.",
	"Cada parte del cuerpo puede subir de nivel de manera independiente del resto.
	Al inicio del juego y cada vez que subamos un nivel nos aparecerá un menú 
	mostrando 3 partes aleatorias, ¡elige la que te apetezca!",
	"Bien! ahora estás mejorando tu 'nombre de la parte', 
	¡cojamos algo de experiencia!",
	"Bien! veamos ahora las barras de experiencia.",
	"Estas son las barras de la mejora actual, 
	necesitarás llenar de experiencia cualquiera de las 5 barras, 
	cuando lo hagas mejorarás esa parte del cuerpo a esa figura. ",
	"Cada barra se llenará de su color, 
	la barra grande se llenará de todos los colores, 
	si esta es la barra que llenas primero obtendrás una 'mejora' al estado ameba.",
	"El estado ameba es el que tienes ahora mismo, 
	no es rápido ni fuerte y su aspecto es algo deprimente,
	 así que deberás evitarlo a toda costa.",
	"Para evitarlo lo recomendable es centrarse en un solo tipo de experiencia, 
	evitando así que la 'barra de ameba' incremente demasiado, Sin embargo...",
	"Esta es tu barra de nivel, como puedes ver incrementa también 
	con la experiencia que obtienes y muestra unos números.",
	"Esos números son tu nivel de poder de cada figura 
	y son independientes en cada parte del cuerpo.",
	"Por tanto, cuanta más experiencia obtengas, 
	más nivel tendrás y más fuerte será tu personaje, 
	pero si eres muy avaricioso te mantendrás en estado ameba y caerás con facilidad.",
	"Cada figura tiene sus fortalezas y debilidades, 
	intenta encontrar tu forma favorita de jugar
	y no te olvides de lo más importante, pasarlo bien :D.",
	"Fin del tutorial, mucha suerte ^^"]
	
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
	Vector2(-374,-232),
	Vector2(-374,-232), 
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	Vector2(),
	]	
func _ready():
	SignalsTrain.isTutorialEnemy.connect(onTutorialEnemyDeath)
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
			
func _on_try_yourself_timeout():
	get_tree().paused = true
	canPressTheButton = true
	explanationText.show()
	$Control/Next.show()
	tryYourselfTimer.stop()

func onTutorialEnemyDeath():
	tryYourselfTimer.start(1)


func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(MENU)
