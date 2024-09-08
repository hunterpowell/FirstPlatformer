extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	body.berries += 1
	animation_player.play("pickup")
	body.switch_sprite(body.sprite_array, 1)
