extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.berries += 1
	queue_free()
