extends Area2D
var hp:=2
var runningaway=false
var speed=1.8
var dir=1
var dead=false
var begchance=42


func _ready() -> void:
	createGas()


func _process(delta: float) -> void:
	if Flags.paused==true:
		return
	
	if (!dead)&& Flags.horror==false:
		position.x-=speed*dir
		


func createGas():
	print("plauge:",position.x)
	Flags.tne.addEvent("gas","level",false,{"pos":position.x})
	Flags.tne.dotime(self,[createGas],Flags.rng.randf_range(.2,1.5),"makegas"+str(get_instance_id()),false,"level")


func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h=true
	dir=-1
	speed+=3

func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1
		Flags.tne.dotime(self,[recourage],3.0,"recourage"+str(self.get_instance_id()),true,"level")
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false

func _on_body_entered(body: Node2D) -> void:
	if dead==true:
		return
	if body.name.find("bullet")>-1:
		hit()
		body.hit()
		return
	if Flags.hat=="beg":
		var begsuccess=Flags.beg(begchance)
		return
	if Flags.inFight==true:
		hit()
	else:
		body.hit()
		
	
func hit():

	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	hp=Flags.calchits(hp)
	if hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		Flags.tne.killTimer("makegas"+str(get_instance_id()),"level")
		return
		
