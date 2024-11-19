extends CharacterBody2D

signal trashable
signal punch

var oldmod
var oldy
var inHit:=false

func _ready():
	oldmod = $AnimatedSprite2D.modulate
	inHit=false

func _process(delta):
	if Flags.pukestate==true:
		puke()

		

func fight():
	$AnimatedSprite2D.animation="fight"+Flags.hat
	$AnimatedSprite2D.play()
	$punch.play()

func revert():
	walkani()



func hit():
	if inHit!=true:
		inHit=true
		
		Flags.playerStats.health-=1
		if Flags.playerStats.health<1:
			kill()

		else:
			oldy=$AnimatedSprite2D.position.y
			var tween = get_tree().create_tween()
			tween.tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x,oldy-25), .1)
			tween.tween_property($AnimatedSprite2D, "modulate", Color(1,0,0,1), .1)
			tween.tween_callback(outhit)

func puke():
	$AnimatedSprite2D.animation="puke"+Flags.hat	

	await get_tree().create_timer(1).timeout
	outpuke()
	
func outpuke():
	Flags.pukestate=false
	$AnimatedSprite2D.animation="default"+Flags.hat
func outhit():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x,oldy), .1)
	tween.tween_property($AnimatedSprite2D, "modulate",oldmod, .1)
	inHit=false
	for i in range(1,10):
		$"..".moveDir(1,false,Flags.dir*-5,false)
		await get_tree().create_timer(0.005).timeout
		

func kill():
	$AnimatedSprite2D.animation="dead"+Flags.hat
	$dead.play()
	Flags.playerDead=true
	var oldmod = $AnimatedSprite2D.modulate
	var tween = get_tree().create_tween()
	
	tween.tween_property($AnimatedSprite2D, "modulate", oldmod, 1)
	tween.tween_callback(restart)
	
func restart():
	if get_node("/root") != null:
		get_node("/root").get_child(1).restart()
	#get_tree().restart()
			

func search():
	$AnimatedSprite2D.animation="search"+Flags.hat
	$AnimatedSprite2D.play()
	#$search.play()
	Flags.inSearch=true;
	Flags.playerSearch=true
	var oldmod = $AnimatedSprite2D.modulate
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", oldmod, 1)
	tween.tween_callback(outSearch)	
	
func _on_rock_body_entered(body):
	hit()

func outSearch():
		Flags.playerSearch=false
		Flags.inSearch=false
		walkani()
	

func walkani():

	if Flags.mesmerized==true:
		

		$AnimatedSprite2D.animation="mesmerized"+Flags.hat

		$AnimatedSprite2D.play()
		return
	if Flags.exhausted==true:
		$AnimatedSprite2D.animation="exhausted"+Flags.hat
	else:
		$AnimatedSprite2D.animation="default"+Flags.hat
	print(Flags.hat)
	print(Flags.mesmerized)
	print ("mesmerized"+Flags.hat)
		
func _on_interact_trashable(body):
	pass


func _on_npc_body_entered(body):

	var count=0
	for x in Flags.playerInventory:
		if (x.type==2):
			$"../npcs/npc".foundQuest();
			Flags.playerInventory.remove_at(count)
		count+=1
#	{"type":type,"item":treenum}
	pass # Replace with function body.
