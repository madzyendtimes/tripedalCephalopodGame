extends Node2D

var rng=RandomNumberGenerator.new()
var treeScene:PackedScene=load("res://tree.tscn")
var enemyScene:PackedScene=load("res://groundling.tscn")
var rockScene:PackedScene=load("res://rock.tscn")
var trashScene:PackedScene=load("res://interact.tscn")
var warpScene:PackedScene=load("res://warp.tscn")
var tvScene:PackedScene=load("res://tv.tscn")
var canJump:=true
var baseSpeed:=1
var speed:=1
var currSpeed:=1
var gy:=0
var gx:=0
var oldmod
var questDistributed:=false
var statScene
var viewStat:=false
var types=[{"name":"trees/tree","num":5},{"name":"trees/buildings/sky","num":4}]
var stanimaAction:=false
var warpS
# Called when the node enters the scene tree for the first time.
func _ready():
	viewStat=false

		
	speed=baseSpeed
	Flags.reset()
	$"..".killStart()
	$treeholder.position.y=-175
	$treeholder2.position.y=-150
	for i in range(0,300):
		var ypos=0
		var nType=0
		if i>100:
			nType=rng.randi_range(0,3)
		
		var ts=get_bg_texture(nType)
		ts.position=Vector2(min(i+(i*.6189),i*3)*75,400)
		ts.flip_h=rng.randi_range(0,1)>0
		var yscale=randf_range(.3,1)
		if nType==1:
			yscale=.54
			ypos=rng.randi_range(75,100)
		ts.scale=Vector2(randf_range(.5,1),yscale)
		

		

		if yscale<.55:
			$treeholder.add_child(ts)
			#ts.material.shader.set("shader_parameter/lod",5.5)
			ts.position.y-=ypos
			
		else: 
			if yscale<.85 && nType==0:
				$treeholder2.add_child(ts)

			else:
				$treeholder3.add_child(ts)
	
#	statScene=statloader.instantiate()
#	add_child(statScene)
	statScene=$stats
	oldmod = $player.modulate
	warpS=warpScene.instantiate()
	warpS.position.y=570
	warpS.position.x=Flags.warploc;
	$interactive.add_child(warpS)
	warpS.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func doEffect():
	#var itemMap:=[{"type":"food","varients":[{"name":"old pizza","effect":"restorehp"},{"name":"noodles... or worms!","effect":"puke|restorehp"},{"name":"suspect sandwitch","effect":"puke"}]},{"type":"scrap","varients":[{"name":"tin foil hat","effect":"stanimaExtend"},{"name":"crushed soda","effect":"recyle"},{"name":"broken mirror","effect":"warp"}]},[{"type":"quest","varients":[{"name":"legs","effect":"quest"}]}]]
	var sEff=Flags.effect
	var aSel = sEff.split("|")
	if aSel.size()>1:
		sEff=aSel[rng.randi_range(0,aSel.size()-1)]		
	match sEff:
		"puke":
			Flags.pukestate=true
		"restorehp":
		
			Flags.playerStats.health=min(Flags.playerStats.health+1,Flags.playerStats.maxHealth)
		"that":
			Flags.hat="that"
			$player/AnimatedSprite2D.animation=$player/AnimatedSprite2D.animation+Flags.hat
			Flags.mesmerized=false
			pass
		"mesmerized":
			Flags.mesmerized=true
			$player.walkani()
		"normal":
			Flags.mesmerized=false
			$player.walkani()
		"recycle":
			pass
		"warp":
			var loc=Flags.warploc
			Flags.warploc=-1*$interactive.position.x
			warpS.position.x=Flags.warploc+550
			var wi=warpScene.instantiate()
			wi.position.x=loc+550
			wi.position.y=550
			$interactive.add_child(wi)
			wi.setanimation("inactive")
			var tween = get_tree().create_tween()
			tween.tween_property($player, "modulate", Color(1,1,1,0), .5)
			tween.tween_callback(warpCB.bind(loc))
			pass
		"quest":
			pass
	Flags.effect=""	
	
func warpCB(loc):
	warpto(loc)
	var tween = get_tree().create_tween()
	tween.tween_property($player, "modulate", oldmod, .5)

func _process(delta):
	

	
	if Flags.paused==true:
		Flags.resetOnce=true
		return
	
	if Flags.effect!="":
		doEffect()
		
	if stanimaAction==true:
		Flags.playerStats.stanima-=Flags.playerStats.stanimaRate
	if Flags.playerStats.stanima<1:
		stanimaAction=false
		Flags.exhausted=true
		$player.walkani()
		speed=0.5
	if stanimaAction==false:
		
		Flags.playerStats.stanima=min(Flags.playerStats.stanima+Flags.playerStats.stanimaRate,Flags.playerStats.maxStanima)
		if Flags.exhausted==true && Flags.playerStats.stanima>(Flags.playerStats.maxStanima/2):
			speed=currSpeed
			Flags.exhausted=false
			$player.walkani()	
					
	var ani:=false
	if Flags.playerDead==true:
		if Input.is_action_just_pressed("reset"):
			stop_fight()
		return
	
	if Input.is_action_just_pressed("reset"):
		if viewStat==true:
			viewStat=false
			Flags.resetOnce=true
			statScene.contract()

		else:
			viewStat=true
			statScene.expand()
			statScene.clear()
			var count:=0
			for i in Flags.playerInventory:
				count+=1
				statScene.addInventory(i,count)
			Flags.resetOnce=false
	
	
	if Input.is_action_pressed("right"):
		Flags.dir=-1
		moveDir(1,true,Flags.dir,true)
		ani=true
	if Input.is_action_pressed("left"):
		Flags.dir=1
		moveDir(1,true,Flags.dir,true)		
		ani=true
		
	if !ani && (Flags.inFight==false && Flags.playerSearch==false):		
		$player/AnimatedSprite2D.pause()
	else:
		$player/AnimatedSprite2D.play()

	if Flags.mesmerized==true:
		return

		
	if Input.is_action_just_pressed("fight")&& canJump==true:
		canJump=false
		Flags.inFight=true
		$player.fight()
		var tween = get_tree().create_tween()
		oldmod = $player.modulate
		tween.tween_property($player, "modulate", oldmod, .65)
		tween.tween_callback(stop_fight)


			
	if Input.is_action_just_pressed("jump") && canJump==true:
		canJump=false
		currSpeed=speed
		speed+=5
		var tween = get_tree().create_tween()
		gy=$player.position.y
		gx=$player.position.x
		$player/jump.play()
		tween.tween_property($player, "position", Vector2(gx,gy-300), .5)
		tween.tween_callback(reset_player)
		
	if Input.is_action_just_pressed("search") && canJump==true:
		#.do_search()
		$player.search()

	if Input.is_action_just_pressed("run") && canJump==true && Flags.exhausted==false:
		speed=4
		stanimaAction=true
	
	if Input.is_action_just_released("run"):
		if Flags.exhausted==false:
			speed=baseSpeed
		
		stanimaAction=false


func moveDir(base,flip,dir,offS):
		$treeholder.position.x+=dir*base*speed 
		$treeholder2.position.x+=dir*(base+0.5)*speed 
		$treeholder3.position.x+=dir*(base+1.5)*speed
		$rocks.position.x+=dir*(base+0.60)*speed
		$npcs.position.x+=dir*(base+0.45)*speed
		$interactive.position.x+=dir*(base+0.45)*speed
		$enemy.position.x+=dir*(base+0.5)*speed
		$locationback.position.x+=dir*(base+0.6)*speed
		$locationfront.position.x+=dir*(base+0.6)*speed
		if flip:
				$player/AnimatedSprite2D.flip_h=(dir==1)
		if dir!=1:
			$player/AnimatedSprite2D.offset=Vector2(0,0)
		else:
			if offS==true:
				$player/AnimatedSprite2D.offset=Vector2(-100,0)


func warpto(base):
		base*=-1
		$treeholder.position.x=base 
		$treeholder2.position.x=(base+0.5)*speed 
		$treeholder3.position.x=(base+1.5)*speed
		$rocks.position.x=(base+0.60)*speed
		$npcs.position.x=(base+0.45)*speed
		$interactive.position.x=(base+0.45)*speed
		$enemy.position.x=(base+0.5)*speed
		$locationback.position.x=(base+0.6)*speed
		$locationfront.position.x=(base+0.6)*speed
		$player/AnimatedSprite2D.offset=Vector2(0,0)

func stop_fight():
		$player.revert()
		$player.modulate=oldmod;
		canJump=true
		Flags.inFight=false
		Flags.playerDead=false
			
func reset_player():
	speed=currSpeed
	var tween = get_tree().create_tween()
	tween.tween_property($player, "position", Vector2(gx,gy), .5).from(Vector2(gx,gy-300))
	tween.tween_callback(reset_flags)

# type=

func reset_flags():
		canJump=true


func get_bg_texture(type):
	if type>types.size()-1:

		type=0
	var name=types[type].name
	var numvariant=types[type].num
	var ts=treeScene.instantiate()
	var treenum=rng.randi_range(1,numvariant)
	var image = Image.load_from_file("res://"+name+str(treenum)+".PNG")
	var texture = ImageTexture.create_from_image(image)
	ts.texture = texture
	return ts
	


func _on_enemy_generator_timeout():
	var upchoice=4

	if $interactive.position.x>-5000 && questDistributed==false:
		upchoice=5
	
	var chance=rng.randi_range(0,upchoice)
#	chance=0
	if chance<1:
		var trash=trashScene.instantiate()
		trash.position.x=(($interactive.position.x)*-1)+1400
		
		$interactive.add_child(trash)	
		return


	if chance<2:
		var rock=rockScene.instantiate()
		rock.position.x=(($rocks.position.x)*-1)+1400;
		rock.get_child(1).flip_h=!rng.randi_range(0,1)>0
		#rock.position.y=0
		rock.setAnimation(str(rng.randi_range(1,3)))
		$rocks.add_child(rock)
		return

	if chance<3:
		var enemy=enemyScene.instantiate()
		enemy.position.y=500
		enemy.position.x=(($enemy.position.x)*-1)+1400
		$enemy.add_child(enemy)
		return
	if chance<4:
		var tv=tvScene.instantiate()
		tv.position.x=(($interactive.position.x)*-1)+1400
		$interactive.add_child(tv)
		return
	
	if chance<5:
		var trash=trashScene.instantiate()
		trash.position.x=(($interactive.position.x)*-1)+1400
		trash.questItem=true
		questDistributed=true
		$interactive.add_child(trash)	
		return
	#move to own generator
#	enemy.connect("collisionMeteor", on_meteor_collision)


func _on_rock_body_entered(body):
	$player.hit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.