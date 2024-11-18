extends Area2D
var dir:=1
signal hit


func _process(delta: float) -> void:
	position.x+=(dir*-1)*10


func _on_area_entered(area: Area2D) -> void:
	hit.emit(area)
	queue_free()
