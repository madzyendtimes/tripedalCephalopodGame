extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func collide():
	$out/CollisionShape2D.disabled=true
	Flags.tne.dotime(self,[recollide],.5,"recollide",true)
	
func recollide():
	$out/CollisionShape2D.disabled=false
