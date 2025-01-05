extends Area2D
var xspeed=5
var yspeed=5
var dir=1
var ydir=1
var freefall=false
var hp=5

func _ready() -> void:
	xspeed=Flags.rng.randi_range(2,7)
	yspeed=Flags.rng.randi_range(2,7)
	position.x=Flags.rng.randi_range(-400,1200)
	position.y=0
	changedir()
	Flags.vol($splode,"fx",8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if freefall:
		position.y+=yspeed
	elif position.y>800:
		queue_free()
		return
#	if position.y>550:
#		ydir=1
	position.x+=xspeed*dir
	position.y+=yspeed*ydir
	


func changedir():
	dir=Flags.rng.randi_range(-1,1)
	if Flags.rng.randi_range(1,100)>85:
		ydir=-1*ydir
	xspeed=Flags.rng.randi_range(2,7)
	yspeed=Flags.rng.randi_range(2,7)
	Flags.tne.dotime(self,[changedir],Flags.rng.randf_range(0.1,1.0),"changedir"+str(get_instance_id()),true,"level")


func _on_body_entered(body: Node2D) -> void:
	if body.name.find("laser")>-1:
		Flags.pitch($splode)
		$splode.play()
		$AnimatedSprite2D.animation="dead"
		freefall=true
		yspeed=10
		Flags.tne.killTimer("changedir"+str(get_instance_id()),"level")
		return
	if !freefall:
		body.hit()
