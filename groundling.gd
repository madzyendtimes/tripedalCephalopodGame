extends Area2D

var path="res://enemies/groundling/"
var dead=false

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
	
func hit():
	$AnimatedSprite2D.animation="dead"
	dead=true
	$hit.play()
	
func _process(delta):
	
	if Flags.paused==true:
		return
	
	if dead==false && Flags.horror==false:
		position.x-=.5
