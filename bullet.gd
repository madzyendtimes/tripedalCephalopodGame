extends CharacterBody2D

var dir=1
var speed=25

func _process(delta: float) -> void:
	position.x+=speed*dir

func start():
	dir=Flags.dir*-1
	Flags.tne.dotime(self,[kill],3.0,"kill"+str(get_instance_id()),true,"level")
	if dir>0:
		position.x+=400
	
func hit(dmg=1):
	queue_free()
	
func kill():
	queue_free()
