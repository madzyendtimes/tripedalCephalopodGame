extends CharacterBody2D
var playerdead=false
var speed=5
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var engaged=false
var firsttime=true
var playerhit=false

func _process(delta: float) -> void:

	if Flags.mode!="witchhut" || playerdead:
		return


	if engaged==false:
		$AnimatedSprite2D.animation="walk"	



	if Input.is_action_pressed("right"):
		if !engaged:
			position.x+=1*speed
			$AnimatedSprite2D.flip_h=false
		
	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h=true
		engaged=false
		position.x-=1*speed
	
	if !engaged:
		return
	
	
func unpress():
	if !playerhit:
		$AnimatedSprite2D.animation="look"
	
func unhit():
	playerhit=false
	$AnimatedSprite2D.animation="look"
	#var tween=get_tree().create_tween()

	
func hit(dmg=1):
	$AnimatedSprite2D.animation="hit"
	playerhit=true

	if Flags.playerStats.health<1:
		$AnimatedSprite2D.animation="dead"
		playerdead=true
		return
		
	Flags.tne.dotime(self,[unhit],1.5,"witchplayerunhit",true,"witchhut")
	
func press():
	$AnimatedSprite2D.animation="press"
	Flags.tne.dotime(self,[unpress],1.0,"witchplayerunpress",true,"witchhut")

func _on_button_body_entered(body: Node2D) -> void:
	if firsttime:
		firsttime=false
		return
	$AnimatedSprite2D.animation="look"
	engaged=true
	$AnimatedSprite2D.flip_h=false
	Flags.witchevents="newrecipe"
