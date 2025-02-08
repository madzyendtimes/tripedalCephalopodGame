extends Node2D
var enemytype=Flags.enemytypes.wallspikes.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sc=Flags.rng.randf_range(.5,1.0)
	scale.x=sc
	scale.y=sc
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func collide():
	Flags.tne.dotime(self,[recollide],.5,"recollide",true)
	
func recollide():
#	$out/CollisionShape2D.disabled=false
	pass



func _on_danger_body_entered(body: Node2D) -> void:
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		return
	
	body.hit(enemytype)
	


func _on_wall_body_entered(body: Node2D) -> void:
	Flags.tne.addEvent("wallon","level",false,{"scale":scale.x})
	pass # Replace with function body.


func _on_wall_body_exited(body: Node2D) -> void:
	Flags.tne.addEvent("walloff","level",false)
	pass # Replace with function body.
