extends Area2D
var hp:=2
var dead:=false
var speed=1
var dir:=1
var runningaway:=false

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
		dotime(recourage,3.0)
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false

func dotime(timefunc,ntime):
	var gt:Timer=Timer.new()
	add_child(gt)
	gt.wait_time=ntime
	gt.one_shot=true			
	gt.timeout.connect(timefunc)
	gt.start()


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
