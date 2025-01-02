extends Area2D



func _on_body_entered(body: Node2D) -> void:
	Flags.tne.addEvent("win","level")
#	Flags.effect="win"
