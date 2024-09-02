extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel
@onready var hud_label: Label = $HUD/hud_label

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins!"
	hud_label.text = "Coins: " + str(score)
