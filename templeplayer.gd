extends CharacterBody2D
;

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var oldy=position.y
var noscale=false
var lastpos=0
var diry:=1
var dirx:=1
var speed=10
var oldscale=1
var olddiry=0
var olddirx=0
var reverted=false
var free=true
var oldtest=floor(position.y/100)
var dead=false

func _process(delta: float) -> void:
	if dead:
		return


	olddiry=diry
	olddirx=dirx
	diry=0
	dirx=0
	if Input.is_action_pressed("down"):
		diry=1
		
	if Input.is_action_pressed("up"):
		diry=-1
		
	if Input.is_action_pressed("left"):
		dirx=-1
		
		
	if Input.is_action_pressed("right"):
		dirx=1
	
	if dirx!=0:
		$AnimatedSprite2D.flip_h=(dirx==-1)
	velocity.x = dirx * SPEED

	velocity.y = diry * SPEED

	#print(get_global_transform())
	move_and_slide()	
	var testy=floor(position.y/100)
	if testy!=oldtest:
		var tempscale=scale.y+(diry/10.0)
		#scale.y=scale.y+(diry/10.0)
		#scale.x=scale.x+(diry/10.0)
		oldtest=testy
		var tween=get_tree().create_tween()
		tween.tween_property(self,"scale",Vector2(tempscale,tempscale),0.3).from_current()


func hit():
	dead=true
	$AnimatedSprite2D.animation="dead"	


func revert():

	pass

	
