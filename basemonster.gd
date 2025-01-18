extends Area2D

var hp:=2
var runningaway=false
var speed=1.8
var dir=1
var dead=false
var begchance=42
var inhit=false

var enemytype={"name":"plaugetestor","flying":false,"hp":2,"begchance":42,"speed":1.8,"pow":1}

func _process(delta: float) -> void:
	if Flags.paused==true:
		return	
	if (!dead)&& Flags.horror==false:
		position.x-=enemytype.speed*dir
		

func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h=true
	dir=-1
	enemytype.speed+=3

func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1
		Flags.tne.dotime(self,[recourage],3.0,"recourage"+str(self.get_instance_id()),true,"level")
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=false
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false

func _on_body_entered(body: Node2D) -> void:
	if dead:
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
	if !inhit:
		inhit=true
		var tween:=get_tree().create_tween()
		var oldy=position.y
		tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
		tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	enemytype.hp=Flags.calchits(enemytype.hp)
	Flags.play("hit")
	if enemytype.hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true
		ondead()	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		return
		
func ondead():
	#userimplementable
	pass
