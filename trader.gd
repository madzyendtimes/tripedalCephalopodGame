extends Node2D
var choice:=6
var lastchoice:=6
var choices:=[
	{"price":99,"effect":"winner","instock":true,"text":"pay to win"},
	{"price":10,"effect":"carryinventory","instock":true,"text":"limited will & testament"},
	{"price":8,"effect":"addstrength","instock":Flags.megaStats.power<(Flags.megaStats.capPower+1),"text":"muscle memory"},
	{"price":8,"effect":"addhealth","instock":Flags.megaStats.health<(Flags.megaStats.capHealth+1),"text":"well fed"},
	{"price":8,"effect":"addspeed","instock":Flags.megaStats.speed<(Flags.megaStats.capSpeed+1),"text":"adhd"},
	{"price":5,"effect":"moneybags","instock":Flags.megaStats.credit!=true,"text":"unlimited credit"},
	{"price":8,"effect":"addstanima","instock":Flags.megaStats.stanima<(Flags.megaStats.capStanima+1),"text":"coffee iv"},
	{"price":999,"effect":"nocap","instock":Flags.megaStats.capPower<1000,"text":"no cap"},
	{"price":15,"effect":"slowspeed","instock":Flags.megaStats.speed>1,"text":"adhd meds"},
	{"price":75,"effect":"doublejump","instock":true,"text":"extra air friction"},
	{"price":75,"effect":"deathgifts","instock":true,"text":"death gifts"},
	{"price":99,"effect":"fistshot","instock":true,"text":"hand cannon"},
	{"price":99,"effect":"flybuddy","instock":true,"text":"B.O."},
	{"price":75,"effect":"levelselect","instock":true,"text":"flat circle dissector"},
	{"price":85,"effect":"transmute","instock":true,"text":"philosopher's reactor"}
	]
var stock:=[]
var home=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$CanvasLayer/music.play()
	$CanvasLayer.visible=false
	select(0)
	#Flags.load() #uncomment to test locally
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Flags.mode!="trader":
		return
	
	$CanvasLayer/playergems.text=str(Flags.megaStats.gems)
	if Input.is_action_just_pressed("up"):
		select(-1)
	if Input.is_action_just_pressed("down"):
		select(1)
	if Input.is_action_just_pressed("jump"):
		purchase()
	if Input.is_action_just_pressed("fight")||Input.is_action_just_pressed("reset"):
		exit()

func start(returnlevel):
	$CanvasLayer.visible=true
	home=returnlevel
	$CanvasLayer/music.play()
	pass

func purchase():
	if Flags.megaStats.gems>=choices[choice-1].price && choices[choice-1].instock==true:
		Flags.megaStats.gems-=choices[choice-1].price
		var canva="CanvasLayer/choices/choice"+str(choice)
		choices[choice-1].instock=false
		get_node(canva).set("theme_override_colors/font_color",Color.RED)
		match choices[choice-1].effect:
			"addhealth":
				Flags.megaStats.health+=1
				Flags.playerStats.maxHealth=Flags.megaStats.health
				Flags.playerStats.health=Flags.megaStats.health

			"addstrength":
				Flags.megaStats.power+=1
				Flags.playerStats.maxPower=Flags.megaStats.power
				Flags.playerStats.power=Flags.megaStats.power

			"slowspeed":
				Flags.megaStats.speed-=1
				Flags.playerStats.maxSpeed=Flags.megaStats.speed
				Flags.playerStats.speed=Flags.megaStats.speed


			"addspeed":
				Flags.megaStats.speed+=1
				Flags.playerStats.maxSpeed=Flags.megaStats.speed
				Flags.playerStats.speed=Flags.megaStats.speed
				
			"addstanima":
				Flags.megaStats.stanima+=100
				Flags.playerStats.maxStanima=Flags.megaStats.stanima
				Flags.playerStats.stanima=Flags.megaStats.stanima
				
			"moneybags":
				Flags.megaStats.credit=true
				Flags.credit=true
				
			"carryinventory":
				Flags.megaStats.inventorycapacity+=1
				
			"winner":
				Flags.effect="win"
				
			"nocap":
				Flags.megaStats.capHealth=10000
				Flags.megaStats.capSpeed=10000
				Flags.megaStats.capPower=10000
				Flags.megaStats.capStanima=10000
				
		$CanvasLayer/AnimatedSprite2D.animation="eat"
		Flags.save()
		Flags.dotime(backtonormal,3.0)		
	pass


func backtonormal():
	$CanvasLayer/AnimatedSprite2D.animation="default"

func exit():
	visible=false
	$CanvasLayer.visible=false
	Flags.mode="level"
	Flags.paused=false
	Flags.interactablenpc.complete()
	$CanvasLayer/music.stop()
	home.intreturn()
	pass

func select(dir):
	lastchoice=choice
	choice=clamp(choice+dir,1,6)
	var canva="CanvasLayer/choices/choice"+str(choice)
	var canvaold="CanvasLayer/choices/choice"+str(lastchoice)


	get_node(canvaold).get_theme_stylebox("normal").bg_color=Color.TRANSPARENT
	get_node(canva).get_theme_stylebox("normal").bg_color=Color.BLACK
	lastchoice=choice	
	
