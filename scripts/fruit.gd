extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.has_berry = true
	queue_free()
