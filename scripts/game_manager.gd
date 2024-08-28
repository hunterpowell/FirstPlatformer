extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins!"
	if score == 0:
		score_label.text = "You collected 0 coins??? you are a massive fucking loser"
	
