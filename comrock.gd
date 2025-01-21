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
		Flags.play("pickaxe")
		if !hitAlready:
			chooseType()
			hitAlready=true
			body.paydirt()
	if body.name=="complayer":
		if hasHit==false:
			hasHit=true
			match id:
				"gem":
					var tmpgem=Flags.rng.randi_range(1,5)+Flags.megaStats.rizz
					Flags.megaStats.gems+=tmpgem
					Flags.play("gemget")
					Flags.tne.addEvent("gem","cryptominos",false,{"gems":tmpgem})
					Flags.save()
				"rock":
					Flags.playerStats.health-=1
					print("hitwith rock")
					Flags.tne.addEvent("hit","cryptominos",false,{"dmg":1})
					Flags.play("hit")
					if Flags.playerStats.health<1:
						var killer=Flags.enemytypes.rock.duplicate()
						killer.variety="falling rock"
						
						Flags.recordDeath(Flags.enemytypes.rock)
						
						gameover(true)
				"skull":				
					Flags.playerStats.health-=3
					Flags.play("hit")					
					Flags.tne.addEvent("hit","cryptominos",false,{"dmg":3})
					if Flags.playerStats.health<1:
						var killer=Flags.enemytypes.rock.duplicate()
						killer.variety="falling skull"
						Flags.recordDeath(Flags.enemytypes.rock)
						gameover(true)
		if $"..":
			queue_free()
