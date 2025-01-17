extends Area2D
var hp:=3
var runningaway=false
var speed=2.5
var dir=1
var dead=false
var begchance=75
var enemytype={"name":"goop baby","flying":false,"hp":3,"begchance":75,"speed":2.5,"pow":2}

func _process(delta: float) -> void:
	if Flags.paused==true:
		return
	
	if (!dead)&& Flags.horror==false:
		position.x-=speed*dir


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
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		hit()
		body.hit()
		return
	if Flags.hat=="beg":
		var begsuccess=Flags.beg(enemytype.begchance)
		return
	if Flags.inFight==true:
		hit()
	else:
		body.hit(enemytype.pow)
		
	
func hit(dmg=1):

	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	hp=Flags.calchits(hp)
	#$hit.play()
	Flags.play("multihit")
	if hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		return

	
	if hp<2:
		$AnimatedSprite2D.animation="short"
		enemytype.pow=1
		speed=1.2
		$collisiontall.position.y=200
		
