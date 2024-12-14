extends Area2D

var type=["rock","gem","skull"]
var hitAlready=false
var staticly=true
var id="rock"
var hasHit=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Flags.entered.active==true:
		if staticly:
			return
		position.y+=175*delta

func chooseType():
	var rng=RandomNumberGenerator.new()
	$AnimatedSprite2D.animation=type[rng.randi_range(0,2)]
	id=$AnimatedSprite2D.animation
func gameover():
	if Flags.entered.active==true:
		Flags.effect="exitenterable"
		Flags.paused=false;
		Flags.entered.active=false
		print("gameover")


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
					Flags.megaStats.gems+=1
					print("gems=",Flags.megaStats.gems)
				"rock":
					Flags.playerStats.health-=1
					print("hitwith rock")
					if Flags.playerStats.health<1:
						gameover()
				"skull":				
					print("hit with skull")
					gameover()
		if $"..":
			queue_free()
	pass # Replace with function body.
