extends Node2D
var type=""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func settype(ptype):
	type=ptype
	$AnimatedSprite2D.animation=ptype
	
func press():
	$AnimatedSprite2D.animation=type+"pressed"
	Flags.dotime(unpress,.7)
	
	
func unpress():
	$AnimatedSprite2D.animation=type
