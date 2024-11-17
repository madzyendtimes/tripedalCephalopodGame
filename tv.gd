extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_active_body_entered(body: Node2D) -> void:
	
	if Flags.hat!="that":
		Flags.mesmerized=true


func _on_active_body_exited(body: Node2D) -> void:
	Flags.mesmerized=false
	Flags.hat=""
	
