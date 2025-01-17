extends Area2D
var hp:=2
var dead:=false
var speed=1.8
var dir:=1
var pow:=1
var runningaway:=false
var begchance=50 #add new playerstat charisma to improve chances
var enemytype={"name":"diaper tooth","flying":false,"hp":2,"begchance":50,"speed":1.8,"pow":1}


func _process(delta: float) -> void:
	if Flags.paused==true:
		return
	
	if (!dead)&& Flags.horror==false:
		position.x-=speed*dir

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
		
	

func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h=true
	dir=-1
	speed+=3
	
	
func hit(dmg=1):
	
	hp=Flags.calchits(hp)
	Flags.play("hit")
#	$hit.play()
	if hp<1:
		$AnimatedSprite2D.animation="diapertoothdead"
		dead=true	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(100*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(100*Flags.dir*-1),oldy), .3)
