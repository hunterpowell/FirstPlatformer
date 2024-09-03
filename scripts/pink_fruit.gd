extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	body.can_slide = true
	animation_player.play("pickup")
	body.which_sprite = 2
