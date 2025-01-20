extends CharacterBody2D

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
var bag=0
var inoffer=false
var oldmod=modulate
var inhit=false
var home=self

func _process(delta: float) -> void:
	
	if Flags.mode!="temple":
		return
	
	if Input.is_action_just_pressed("reset"):
		Flags.playerStats.health=10
		dead=false
		inhit=false
		inoffer=false
		bag=0
		
		walk()
		
		$"..".reset()
		$"..".devstart()

	if dead or inoffer or Flags.mode!="temple":
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
	velocity.x = dirx * (SPEED+(Flags.playerStats.speed*50))

	velocity.y = diry * (SPEED+(Flags.playerStats.speed*50))

	move_and_slide()	
	var testy=floor(position.y/100)
	if testy!=oldtest:
		var tempscale=scale.y+(diry/10.0)
		#scale.y=scale.y+(diry/10.0)
		#scale.x=scale.x+(diry/10.0)
		oldtest=testy
		var tween=get_tree().create_tween()
		tween.tween_property(self,"scale",Vector2(tempscale,tempscale),0.3).from_current()

func start(callee):
	home=callee


func makeoffer():
	if dead:
		$AnimatedSprite2D.animation="dead"	
		return
		
	$AnimatedSprite2D.animation="front"
	inoffer=true
	Flags.tne.dotime(self,[walk],1.6,"walk",true,"temple")
	
func offer():
	Flags.tne.dotime(self,[makeoffer],0.5,"makeoffer",true,"temple")


func hit(dmg=1):
	inhit=true
	$AnimatedSprite2D.animation="hit"
	Flags.play("die")
	Flags.playerStats.health-=1
	stat("-","health",1)
	if Flags.playerStats.health<1:
		dead=true
		$AnimatedSprite2D.animation="dead"
		Flags.recordDeath(Flags.enemytypes.ghost)
		home.exit(true)
		return	
	Flags.tne.dotime(self,[outhit],1.4,"outhit",true,"temple")



func outhit():
	inhit=false
	walk()

func walk():
	if dead:
		$AnimatedSprite2D.animation="dead"	
		return	
	if inhit:
		return
	inoffer=false
	$AnimatedSprite2D.animation="walk"
	if bag>9:
		$AnimatedSprite2D.animation="fullbag"

func clean(type="trash"):
	if inhit:
		return
	if dead:
		$AnimatedSprite2D.animation="dead"
		return	
	$AnimatedSprite2D.animation="pickup"
	bag+=1
	print(type)
	if type=="gem":
		var tmpg=Flags.rng.randi_range(1,5)+Flags.playerStats.rizz
		Flags.megaStats.gems+=tmpg
		stat("+","gem",tmpg)		
		Flags.save()
	Flags.tne.dotime(self,[walk],0.6,"walk",true,"temple")

func revert():

	pass

func stat(mth,ptype,amount):
	$templestat.visible=true
	
	var showamount=str(amount)
	if amount==0:
		showamount=""
	$templestat/Label.text=mth+" "+showamount
	$templestat/AnimatedSprite2D.animation=ptype

	Flags.tne.dotime(self,[unstat],1.5,"unstat",true,"temple")


func unstat():
	$templestat.visible=false
	pass
