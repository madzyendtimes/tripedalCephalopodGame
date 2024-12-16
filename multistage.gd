extends Area2D
var hp:=3
var runningaway=false
var speed=2.5
var dir=1
var dead=false
var begchance=75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if Flags.paused==true:
		return
	
	if (!dead)&& Flags.horror==false:
		position.x-=speed*dir

func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1
		Flags.dotime(recourage,3.0)
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false

func _on_body_entered(body: Node2D) -> void:
	if dead==true:
		return
	if Flags.hat=="beg":
		var begsuccess=Flags.beg(begchance)
		return
	if Flags.inFight==true:
		hit()
	else:
		Flags.effect="hit"
		
	
func hit():

	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	hp=Flags.calchits(hp)
	if hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		return

	
	if hp<2:
		$AnimatedSprite2D.animation="short"
		speed=1.2
		$collisiontall.position.y=200
		
