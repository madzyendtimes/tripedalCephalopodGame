extends Area2D

var hp=1
var dir=-1
var runningaway=false
var speed=3
var enemytype=Flags.enemytypes.gemmonster.duplicate()

func _process(delta: float) -> void:
	if position.x<-200 && Flags.mode=="witchhut":
			Flags.tne.addEvent("gemcaught","witchhut")
			queue_free()
			return

	position.x+=dir*enemytype.speed



func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h
	dir=-1
	enemytype.speed+=4
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
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
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
			body.hit(enemytype)






func hit(dmg=1):
	enemytype.hp=Flags.calchits(enemytype.hp)
	if enemytype.hp<1:
		Flags.tne.addEvent("addgems","level")
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		#Flags.effect="addgems"
		queue_free()
	else:
		knockback()
	
	

		
