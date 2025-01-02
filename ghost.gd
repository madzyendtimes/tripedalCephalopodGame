extends Area2D
var type="peace"
var speed=1
var tx=0
var ty=0

var xbound=1400
var ybound=1000
var xboundo=-1400
var yboundo=-700
var oldx=0
var oldy=0

func _ready() -> void:
	var tempt=Flags.rng.randi_range(1,3)
	if tempt==1:
		type="holy"
	if tempt==2:
		type="demon"
	if tempt==3:
		type="peace"
	$AnimatedSprite2D.animation=type		
	$AnimatedSprite2D.play()
	getdir()

func dissapear(variant):
	if type==variant:
		kill()

func getdir():
	tx=Flags.rng.randi_range(-1,1)

	ty=Flags.rng.randi_range(-1,1)

	Flags.tne.dotime(self,[getdir],Flags.rng.randf_range(.2,1.5),"getdir"+str(self.get_instance_id()),true,"temple")


func _process(delta: float) -> void:
	position.y=clamp(position.y+ty*speed,yboundo,ybound)
	position.x=clamp(position.x+tx*speed,xboundo,xbound)


func kill():
	Flags.tne.killTimer("getdir"+str(self.get_instance_id()),"temple")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.hit()
	
func hit():
	pass
