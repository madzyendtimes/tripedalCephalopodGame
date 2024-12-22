extends Node2D

func _ready() -> void:
	if Flags.controlScheme=="keyboard":
		$Jumptutorial.animation="keyboardtext"
