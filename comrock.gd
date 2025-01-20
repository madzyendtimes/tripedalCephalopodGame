extends Area2D

var type=["rock","gem","skull"]
var hitAlready=false
var staticly=true
var id="rock"
var hasHit=false

func _process(delta: float) -> void:
	if Flags.entered.active==true:
		if staticly:
			return
		position.y+=175*delta

func chooseType():
	$AnimatedSprite2D.animation=type[Flags.rng.randi_range(0,2)]
	id=$AnimatedSprite2D.animation
func gameover(isdead=false):
	if Flags.mode=="cryptominos":
		Flags.paused=false;
		Flags.entered.active=false
		print("gameover")
	if isdead:
		Flags.tne.addEvent("dead","cryptominos",true)
	else:	
		Flags.tne.addEvent("dead","cryptominos",true)


func _on_body_entered(body: Node2D) -> void:
	if body.name.find("pickaxe")>-1:
		staticly=false
		if !hitAlready:
			chooseType()
			hitAlready=true
			body.paydirt()
	if body.name=="complayer":
		if hasHit==false:
			hasHit=true
			match id:
				"gem":
					Flags.megaStats.gems+=Flags.randi_range(1,5)+Flags.megaStats.rizz
					Flags.save()
				"rock":
					Flags.playerStats.health-=1
					print("hitwith rock")
					if Flags.playerStats.health<1:
						gameover(true)
				"skull":				
					print("hit with skull")
					gameover()
		if $"..":
			queue_free()
