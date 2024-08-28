extends Area2D

@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	body.alive = false
	body.hit_sound.play()
	#sets game to half speed on death
	Engine.time_scale = 0.5
	timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
