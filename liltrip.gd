extends StaticBody2D
var state="rest"
var speed=2
var change=1
var pow=1
var xmax=500
var dir=1
var rightexit=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()

func start():
	$AnimatedSprite2D.play()
	position.x=500
	dochange()	
				
func dochange():
	var newstate=Flags.rng.randi_range(0,100)
	Flags.tne.dotime(self,[dochange],Flags.rng.randf_range(0.25,1.5),"dochange"+str(get_instance_id()),true,"level")
	if !Flags.petmove:
		newstate=35
	if newstate<25:
		state="rest"
		speed=0
		$AnimatedSprite2D.animation="rest"
		$AnimatedSprite2D.play()
		return		
	if newstate<50:
		state="walk"
		speed=randi_range(1,5)
		$AnimatedSprite2D.animation="walk"
		$AnimatedSprite2D.play()
		return
	if newstate<75:
		state="attack"
		$AnimatedSprite2D.animation="attack"
		$AnimatedSprite2D.play()
		return
	state="walk"
	$AnimatedSprite2D.animation="walk"
	$AnimatedSprite2D.play()
	$AnimatedSprite2D.flip_h=!$AnimatedSprite2D.flip_h
	dir*=-1
	speed=Flags.rng.randi_range(1,5)	

func _process(delta: float) -> void:

	position.x+=speed*dir
	
	#global_position.x=clamp(global_position.x+(speed*dir),get_parent().position.x*-1,(get_parent().position.x+600)*-1)
	#print(position.x," -- ",global_position.x, " --:-- ",get_parent().position.x)
	
func hit(enemytype={}):
	print("pethit")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#print("whoaoh ",rightexit)
	#print(position.x," -- ",global_position.x, " --:-- ",get_parent().position.x)
	Flags.petmove=false
	if rightexit:
		dir=-1
		speed=8
		$AnimatedSprite2D.animation="walk"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h=true
	else:
		dir=1
		speed=8
		$AnimatedSprite2D.animation="walk"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h=false
			
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	Flags.petmove=true


func _on_right_screen_exited() -> void:
	rightexit=true
	#print("rightexit")


func _on_left_screen_exited() -> void:
	rightexit=false
	#print("leftexit")
