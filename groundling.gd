extends Area2D

var path="res://enemies/groundling/"
var dead=false
var runningaway:=false
var dir=1
var hp=1
var begchance=25
var speed=.7
var enemytype={"name":"groundling","flying":false,"hp":1,"begchance":25,"speed":.75}


func _ready() -> void:
	$hit.volume_db=Flags.options.fx
	$die.volume_db=Flags.options.fx

func polarity(canpolarity):
	if !canpolarity:
		return
	$AnimatedSprite2D.flip_h=true
	dir=-1
	speed+=3

func _on_body_entered(body):
	if dead:
		return

	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		$hit.play()
		body.hit()
		return



	if Flags.hat=="beg":
		var begsuccess=Flags.beg(begchance)
		return
	if Flags.inFight==true:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		$hit.play()
	else:
		$die.play()
		body.hit()
	
func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1	
		$AnimatedSprite2D.flip_h=true

		Flags.tne.dotime(self,[recourage],3.0,"recourage"+str(self.get_instance_id()),true,"level")

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false
	
func hit():
	hp=Flags.calchits(hp)
	if hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		$hit.play()

	
func _process(delta):
	
	if Flags.paused==true:
		return
	
	if dead==false && Flags.horror==false:
		position.x-=speed*dir
