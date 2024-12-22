extends Node2D



func _ready() -> void:
	$AnimatedSprite2D.animation="read"
	$AnimatedSprite2D.play()
