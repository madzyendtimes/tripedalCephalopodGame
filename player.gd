extends CharacterBody2D

signal trashable
signal punch

var oldmod
var oldy
var inHit:=false

func _ready():
	oldmod = $AnimatedSprite2D.modulate
	inHit=false


func fight():
	$AnimatedSprite2D.animation="fight"
	$AnimatedSprite2D.play()
	$punch.play()

func revert():
	$AnimatedSprite2D.animation="default"


func hit():
	if inHit!=true:
		inHit=true
		print(Flags.playerStats.health)
		Flags.playerStats.health-=1
		if Flags.playerStats.health<1:
			kill()

		else:
			oldy=$AnimatedSprite2D.position.y
			var tween = get_tree().create_tween()
			tween.tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x,oldy-25), .1)
			tween.tween_property($AnimatedSprite2D, "modulate", Color(1,0,0,1), .1)
			tween.tween_callback(outhit)



func outhit():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "position", Vector2($AnimatedSprite2D.position.x,oldy), .1)
	tween.tween_property($AnimatedSprite2D, "modulate",oldmod, .1)
	inHit=false
	for i in range(1,10):
		$"..".moveDir(1,false,Flags.dir*-5,false)
		await get_tree().create_timer(0.005).timeout
		

func kill():
	$AnimatedSprite2D.animation="dead"
	$dead.play()
	Flags.playerDead=true
	var oldmod = $AnimatedSprite2D.modulate
	var tween = get_tree().create_tween()
	
	tween.tween_property($AnimatedSprite2D, "modulate", oldmod, 1)
	tween.tween_callback(restart)
	
func restart():
	if get_node("/root") != null:
		print(get_node("/root").get_child(1).restart())
	#get_tree().restart()
			

func search():
	$AnimatedSprite2D.animation="search"
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
		$AnimatedSprite2D.animation="default"


func _on_interact_trashable(body):
	pass


func _on_npc_body_entered(body):
	print("npc hit")
	var count=0
	for x in Flags.playerInventory:
		if (x.type==2):
			$"../npcs/npc".foundQuest();
			Flags.playerInventory.remove_at(count)
		count+=1
#	{"type":type,"item":treenum}
	pass # Replace with function body.
