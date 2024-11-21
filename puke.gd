extends Area2D
signal pukehit






func _on_area_entered(area: Area2D) -> void:
	pukehit.emit(area)
