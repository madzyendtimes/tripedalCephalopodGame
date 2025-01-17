extends Area2D
var active=false
var speed=5


func _process(delta: float) -> void:
	if active:
		position.x=position.x-speed

func hit(dmg=1):
	pass

func kill():
	active=false
	queue_free()


func start():
	active=true
	position.y+=Flags.rng.randi_range(-50,50)
	Flags.tne.dotime(self,[kill],5.0,"killneedle"+str(get_instance_id()),true,"level")

func _on_body_entered(body: Node2D) -> void:
	if body.name.find("bullet")>-1:
		kill()
		return
	
	body.hit(1)
	body.scale.y=body.scale.y-.2
	body.scale.x=body.scale.x-.2
	kill()
