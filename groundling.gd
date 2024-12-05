extends Area2D

var path="res://enemies/groundling/"
var dead=false
var runningaway:=false
var dir=1

func _on_body_entered(body):
	if dead==true || Flags.hat=="beg":
		return
	if Flags.inFight==true:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		$hit.play()
	else:
		$die.play()
		$"../../player".hit()
	
func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1	
		$AnimatedSprite2D.flip_h=true
		Flags.dotime(recourage,3.0)

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false
	
func hit():
	$AnimatedSprite2D.animation="dead"
	dead=true
	$hit.play()
	
func _process(delta):
	
	if Flags.paused==true:
		return
	
	if dead==false && Flags.horror==false:
		position.x-=.5*dir
