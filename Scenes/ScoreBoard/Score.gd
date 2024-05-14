extends Node

var time : String
var kills : int = 0
var score : int 
var userName : String

func setScore():
	var timeNumbers = time.split(":")
	score = (kills * 1000) + (int(timeNumbers[0]) * 600) + (int(timeNumbers[1]) * 10)
	

