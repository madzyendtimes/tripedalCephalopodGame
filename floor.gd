extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name.find("pickaxe")>-1:
		body.queue_free()
