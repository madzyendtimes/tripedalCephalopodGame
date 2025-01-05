extends CharacterBody2D

signal trashable
signal punch

var isinoffset=false
var oldmod
var oldy
var inHit:=false
var crouched=false

var colcollect=[
	{"name":"fight","offset":false,"flip":false,"scene":$fight},
	{"name":"fightoffset","offset":true,"flip":false,"scene":$fightoffset},
	{"name":"offset","offset":true,"flip":false,"scene":$offset},
	{"name":"normal","offset":false,"flip":false,"scene":$normal},
	{"name":"crouch","offset":false,"flip":false,"scene":$normal},
	{"name":"spin","offset":false,"flip":false,"scene":$normal}
]


func _ready():
	setCollision("normal")
	Flags.playerposition=self.position
	Flags.playerscale=self.scale
	oldmod = $AnimatedSprite2D.modulate
	inHit=false
	$dead.volume_db=Flags.options.fx
	$punch.volume_db=Flags.options.fx
	$search.volume_db=Flags.options.fx
	$jump.volume_db=Flags.options.fx
	$AnimatedSprite2D.material.set_shader_parameter("lowgraphic",Flags.options.graphics=="low")

func setCollision(type):
		for i in colcollect:
			if i.name==type:
				get_node(i.name).disabled=false
			else:
				get_node(i.name).disabled=true



func _process(delta):
	if Flags.pukestate==true:
		puke()

func dooffset(boff):
	isinoffset=boff
	if Flags.inCrouch:
		return
	isinoffset=boff
	if boff:
		$AnimatedSprite2D.offset=Vector2(-100,0)
		#setCollision("offset")

	else:
		$AnimatedSprite2D.offset=Vector2(0,0)
		#setCollision("normal")

func spin():
	$AnimatedSprite2D.animation="spin"
	setCollision("spin")
	Flags.spinned=true

func unspin():
	revert()

func uncrouch():
	Flags.inCrouch=false
	crouched=false
	revert()

func crouch():
	$AnimatedSprite2D.animation="crouch"
	setCollision("crouch")
	crouched=true

func flip(bflip):
	$AnimatedSprite2D.flip_h=bflip

func fight():
	if Flags.inJump:
		spin()
		return
	$AnimatedSprite2D.animation="fight"+Flags.hat+Flags.fightmode
	$AnimatedSprite2D.play()
	$punch.play()
	if isinoffset:
		setCollision("fightoffset")
	else:
		setCollision("fight")
	if Flags.fightmode=="gun":
		Flags.tne.addEvent("shot","level",true)

	
	
func warn():
	$AnimatedSprite2D.material.set_shader_parameter("rate",2.5)
	$AnimatedSprite2D.material.set_shader_parameter("doblink",true)
	#$AnimatedSprite2D.get_material().set_shader_param("rate",2.2)

	
func unwarn():
	$AnimatedSprite2D.material.set_shader_parameter("doblink",false)
	#$AnimatedSprite2D.get_material().set_shader_param("rate",0.0)

func revert():
	setCollision("normal")
	Flags.inCrouch=false
	walkani()

func resisted():
	$stat/Label.text="RESISTED "
	$stat/AnimatedSprite2D.animation="tv"
	$stat.visible=true
	Flags.tne.dotime(self,[unstat],1.5,"unstat",true,"level")

func stat(mth,ptype,amount):
	$stat/Label.text=mth+" "+str(amount)
	$stat/AnimatedSprite2D.animation=ptype
	$stat.visible=true
	Flags.tne.dotime(self,[unstat],1.5,"unstat",true,"level")

func unstat():
	$stat.visible=false

func hit(dmg=1):
	if Flags.special=="ufo":
		return
	if inHit!=true:
		inHit=true
		stat("-","health",dmg)
		Flags.playerStats.health-=dmg
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
func enter():
	$AnimatedSprite2D.animation="forward"
	$AnimatedSprite2D.play()


func confused():
	$stat/Label.text="CONFUSED "
	$stat/AnimatedSprite2D.animation="confused"
	$stat.visible=true
	Flags.tne.dotime(self,[unstat],1.5,"unstat",true,"level")


func walkani():


	if Flags.playerDead:
		$AnimatedSprite2D.animation="dead"+Flags.hat
		return

	if Flags.inCrouch:
		crouch()
		return


	if Flags.mesmerized==true:
		

		$AnimatedSprite2D.animation="mesmerized"+Flags.hat

		$AnimatedSprite2D.play()
		return
	if Flags.exhausted==true:
		$AnimatedSprite2D.animation="exhausted"+Flags.hat
	else:
		$AnimatedSprite2D.animation="default"+Flags.hat
		
