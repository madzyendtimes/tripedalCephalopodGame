extends Area2D

var path="res://enemies/groundling/"
var dead=false

func _on_body_entered(body):
	if dead==true:
		return
	if Flags.inFight==true:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		$hit.play()
	else:
		$die.play()
		$"../../player".hit()
	

func _process(delta):
	
	if Flags.paused==true:
		return
	
	if dead==false:
		position.x-=.5


