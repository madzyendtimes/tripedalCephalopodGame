extends Node2D
var choice:=6
var lastchoice:=6
var choices:=[{"price":99,"effect":"winner","instock":true},{"price":10,"effect":"carryinventory","instock":true},{"price":08,"effect":"addstrength","instock":true},{"price":08,"effect":"addhealth","instock":true},{"price":08,"effect":"addspeed","instock":true},{"price":05,"effect":"moneybags","instock":true}]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/music.play()
	select(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/playergems.text=str(Flags.megaStats.gems)
	if Input.is_action_just_pressed("up"):
		select(-1)
	if Input.is_action_just_pressed("down"):
		select(1)
	if Input.is_action_just_pressed("jump"):
		purchase()
	if Input.is_action_just_pressed("fight"):
		exit()

func purchase():
	if Flags.megaStats.gems>=choices[choice-1].price && choices[choice-1].instock==true:
		Flags.megaStats.gems-=choices[choice-1].price
		var canva="CanvasLayer/choices/choice"+str(choice)
		choices[choice-1].instock=false
		get_node(canva).set("theme_override_colors/font_color",Color.RED)
		match choices[choice-1].effect:
			"addhealth":
				Flags.megaStats.health+=1
			"adstrength":
				Flags.megaStats.power+=1
			"addspeed":
				Flags.megaStats.speed+=1
			"moneybags":
				Flags.megaStats.credit=true
			"carryinventory":
				Flags.megaStats.inventorycapacity+=1
			"winner":
				Flags.effect="win"
		$CanvasLayer/AnimatedSprite2D.animation="eat"
		Flags.dotime(backtonormal,3.0)		
	pass


func backtonormal():
	$CanvasLayer/AnimatedSprite2D.animation="default"

func exit():
	pass

func select(dir):
	lastchoice=choice
	choice=clamp(choice+dir,1,6)
	var canva="CanvasLayer/choices/choice"+str(choice)
	var canvaold="CanvasLayer/choices/choice"+str(lastchoice)


	get_node(canvaold).get_theme_stylebox("normal").bg_color=Color.TRANSPARENT
	get_node(canva).get_theme_stylebox("normal").bg_color=Color.BLACK
	lastchoice=choice	
	
