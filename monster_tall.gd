extends Area2D
var hp:=2
var dead:=false
var speed=1
var dir:=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Flags.paused==true:
		return
	
	if (!dead):
		position.x-=speed*dir


func _on_body_entered(body: Node2D) -> void:
	if dead==true || Flags.hat=="beg":
		return
	if Flags.inFight==true:
		hit()
	else:
		Flags.effect="hit"
		
	
func hit():
	hp-=Flags.playerStats.power
	if hp<1:
		$AnimatedSprite2D.animation="diapertoothdead"
		dead=true	
		#$hit.play()
	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(100*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(100*Flags.dir*-1),oldy), .3)
