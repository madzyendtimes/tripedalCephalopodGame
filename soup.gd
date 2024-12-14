extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func ouch():
	$AnimatedSprite2D.animation="ouch"
	Flags.dotime(calm,0.5)


func calm():
	$AnimatedSprite2D.animation="calm"

func splash():
	$AnimatedSprite2D.animation="splash"
	Flags.dotime(calm,0.5)
