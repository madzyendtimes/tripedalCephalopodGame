extends Area2D
var type="demon"
var xdir=1
var ydir=1
var speed=Flags.rng.randi_range(1,4)
var maxchange=3.0
var active=false
var home=self


func _ready() -> void:
	var rnd=Flags.rng.randi_range(1,3)
	if rnd==1:
		maxchange=3.0
		$AnimatedSprite2D.animation="holy"
	if rnd==2:
		$AnimatedSprite2D.animation="peace"
		maxchange=5.0
	if rnd==3:
		$AnimatedSprite2D.animation="demon"
		maxchange=2.0
	visible=false


func kill():
	active=false
	visible=false
	Flags.tne.killTimer("changedir"+str(self.get_instance_id()),"level")
	queue_free()

func start(callee):
	home=callee		
	active=true
	visible=true
	changedir()
	
func _process(delta: float) -> void:
	if active==true:
		position.x=clamp(-600,600,position.x+speed*xdir)
		position.y=clamp(-10,+750,position.y+speed*ydir)
	
func hit():
	pass

func changedir():
	xdir=Flags.rng.randi_range(-1,1)
	ydir=Flags.rng.randi_range(-1,1)
	Flags.tne.dotime(self,[changedir],Flags.rng.randf_range(.2,maxchange),"changedir"+str(self.get_instance_id()),true,"level")
	speed=Flags.rng.randi_range(1,4)


func _on_body_entered(body: Node2D) -> void:
	if active:
		body.hit()
		
