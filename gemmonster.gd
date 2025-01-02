extends Area2D

var hp=1
var dir=-1
var runningaway=false
var speed=3



func _process(delta: float) -> void:
	if position.x<-200 && Flags.mode=="witchhut":
			Flags.witchevents="gemcaught"
			queue_free()
			return

	position.x+=dir*speed



func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h
	dir=-1
	speed+=4
	$AnimatedSprite2D.flip_h=true
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

func knockback():
	pass

func _on_body_entered(body: Node2D) -> void:
	
	if body.name.find("bullet")>-1:
		hit()
		body.hit()
		return
	if Flags.mode=="level":
		if Flags.hat=="beg":
			var begsuccess=Flags.beg(101)
			queue_free()
			return	
		if Flags.inFight==true && Flags.playerHits>0:
			hit()
		else:
			body.hit()




func hit():
	hp=Flags.calchits(hp)
	if hp<1:
		Flags.tne.addEvent("addgems","level")
		#Flags.effect="addgems"
		queue_free()
	else:
		knockback()
	
	

		
