extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sc=Flags.rng.randf_range(.5,1.25)
	scale.x=sc
	scale.y=sc
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func collide():
	$out/CollisionShape2D.disabled=true
	Flags.tne.dotime(self,[recollide],.5,"recollide",true)
	
func recollide():
	$out/CollisionShape2D.disabled=false


func _on_body_entered(body: Node2D) -> void:
	Flags.tne.addEvent("wallon","level",false,{"scale":scale.x})
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	Flags.tne.addEvent("walloff","level",false)
	pass # Replace with function body.
