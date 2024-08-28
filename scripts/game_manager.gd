extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins!"
	if score == 1:
		score_label.text = "You collected 1 coin??? that's it?!?!? you are a massive fucking nerd"
	
