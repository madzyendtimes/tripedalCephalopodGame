extends Node2D
signal hit
signal pukehit
signal begout
signal timeout
var rng=RandomNumberGenerator.new()
var treeScene:PackedScene=load("res://tree.tscn")
var enemyScene:PackedScene=load("res://groundling.tscn")
var rockScene:PackedScene=load("res://rock.tscn")
var trashScene:PackedScene=load("res://interact.tscn")
var warpScene:PackedScene=load("res://warp.tscn")
var tvScene:PackedScene=load("res://tv.tscn")
var missleScene:PackedScene=load("res://missle.tscn")
var pukeScene:PackedScene=load("res://puke.tscn")
var expanderScene:PackedScene=load("res://expander.tscn")
var tallmScene:PackedScene=load("res://monster_tall.tscn")
var welcomeScene:PackedScene=load("res://welcome_center.tscn")
var assetsScene:PackedScene=load("res://assets.tscn")
var enterScene:PackedScene=load("res://enterable.tscn")
var flavorScene:PackedScene=load("res://flavornpc.tscn")
var flyerScene:PackedScene=load("res://flyer.tscn")
var multiScene:PackedScene=load("res://multistage.tscn")
var canJump:=true
var baseSpeed=Flags.megaStats.speed
var speed=baseSpeed
var currSpeed=speed
var gy:=0
var gx:=0
var oldmod
var questDistributed:=false
var statScene
var viewStat:=false
var types=[{"name":"trees/tree","num":5},{"name":"trees/buildings/sky","num":4}]
var stanimaAction:=false
var warpS
var missle
var dangerZone
var canrandom=true

# Called when the node enters the scene tree for the first time.
func _ready():
	Flags.titlescreen="title"
	viewStat=false
	$trader.visible=false	
	Flags.reset()
	baseSpeed=Flags.megaStats.speed
	speed=baseSpeed
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
		ts.modulate=Color(rng.randf_range(0.0,1.0),rng.randf_range(0.0,1.0),rng.randf_range(0.0,1.0))

		

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
	var welcome=welcomeScene.instantiate()
	$locationfront.add_child(welcome)
	welcome.position=Vector2(min(301+(301*.6189),301*3)*100,400)

	dangerZone={"less":4114,"more":welcome.position.x-3000}
	statScene=$stats
	oldmod = $player.modulate
	warpS=warpScene.instantiate()
	warpS.position.y=570
	warpS.position.x=Flags.warploc;
	$interactive.add_child(warpS)
	warpS.play()
	#uncomment to test gemna
	#speed=1
	#warpto(34000)
	#this sets off the spawntimer testing before removing old static enemyGeneraator
	dospawns()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func horrorend():
	Flags.horror=false
func dohorror():
	var timer=get_tree().create_timer(rng.randf_range(0.5,2)).timeout
	Flags.horror=true
	$random.position.y=-1500
	var tween=get_tree().create_tween()
	tween.tween_property($random,"modulate",Color(1,1,1,0),.5)
	tween.tween_callback(horrorflash)
	Flags.dotime(horrorend,5)


func horrorflash():
	$random.position.y=0
	var tween=get_tree().create_tween()
	tween.tween_property($random,"modulate",Color(1,1,1,1),.5)		

func triggerhorror():
	Flags.dotime(dohorror,rng.randf_range(0.5,5.0))
	

func setShaderParam(parm,val):
	$Camera2D/CanvasLayer/colorect.material.set_shader_parameter(parm,val)



func dopuke():
	Flags.pukestate=true
	if !$player/AnimatedSprite2D.is_playing():
		$player/AnimatedSprite2D.play()
	renderPuke()

func randpuke():	
	Flags.dotime(dopuke,rng.randf_range(0.0,2.0));			
	if Flags.radiation==true:
		Flags.dotime(randpuke,1.0)

func radiationend():
	Flags.radiation=false
	var tween=get_tree().create_tween()
	tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/brightness",1.0,1.0)
	tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/contrast",1.0,1.0)
	tween.parallel().tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/saturation",1.0,1.0)


func doEffect():
	if Flags.mode!="level":
		return
	#var itemMap:=[{"type":"food","varients":[{"name":"old pizza","effect":"restorehp"},{"name":"noodles... or worms!","effect":"puke|restorehp"},{"name":"suspect sandwitch","effect":"puke"}]},{"type":"scrap","varients":[{"name":"tin foil hat","effect":"stanimaExtend"},{"name":"crushed soda","effect":"recyle"},{"name":"broken mirror","effect":"warp"}]},[{"type":"quest","varients":[{"name":"legs","effect":"quest"}]}]]
	var sEff=Flags.effect
	var aSel = sEff.split("|")
	if aSel.size()>1:
		sEff=aSel[rng.randi_range(0,aSel.size()-1)]		
	print(sEff)
	match sEff:
		"changeweather":
			changeweather()
		"spendingspree":
			Flags.credit=true
		"getgems":
			Flags.megaStats.gems+=rng.randi_range(1,3)
		"radiation":
			Flags.radiation=true;
			randpuke()
			var radtime=rng.randi_range(1,10)
			var tween=get_tree().create_tween()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/brightness",8.0,1.5).from_current()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/contrast",5.0,1.0).from_current()
			tween.parallel().set_loops(radtime).tween_property($Camera2D/CanvasLayer/colorect,"material:shader_parameter/saturation",6.0,1.0).from_current()
			tween.tween_callback(radiationend)
			#$Camera2D/CanvasLayer/colorect.material.set_shader_parameter("contrast",10.0)
			#$Camera2D/CanvasLayer/colorect.material.set_shader_parameter("saturation",10.0)
		"horror":
			triggerhorror()
		"exitcryptominos":			
			warpCB(Flags.conveniance.oldloc*-1)
			Flags.paused=false
			$player/AnimatedSprite2D.play()
			var tween=get_tree().create_tween()
			tween.parallel().tween_property($player,"scale",Flags.playerscale,.5)
			tween.parallel().tween_property($player,"position",Flags.playerposition,.5)
			$player.walkani()
			#tween.tween_callback(entered)		
					
		"puke":
			dopuke()
		"restorehp":
		
			Flags.playerStats.health=min(Flags.playerStats.health+1,Flags.playerStats.maxHealth)
		"that":
			Flags.hat="that"
			$player/AnimatedSprite2D.animation=$player/AnimatedSprite2D.animation+Flags.hat
			Flags.mesmerized=false
			$player.walkani()
			Flags.dotime(returnhat,30.0)
		"controlled":
			Flags.controlled=true
			$player.walkani()
		"mesmerized":
			Flags.mesmerized=true
			$player.walkani()
		"normal":
			Flags.mesmerized=false
			Flags.controlled=false
			$player.walkani()
		"kick":
			missle=missleScene.instantiate()
			$interactive.add_child(missle)
			missle.position.x=($interactive.position.x*-1)+550
			missle.position.y=550
			missle.dir=Flags.dir
			missle.hit.connect(missleHit)
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
		"beg":
			Flags.hat="beg"
			$player/AnimatedSprite2D.animation=$player/AnimatedSprite2D.animation+Flags.hat
			Flags.dotime(returnbeg,30.0)
				
		"stanima":
			Flags.playerStats.bonusStanima=Flags.playerStats.maxStanima
			Flags.playerStats.stanima=Flags.playerStats.maxStanima
			Flags.dotime(returnBonus.bind("stanima"),10.0)
		"quest":
			pass
		"hit":
			$player.hit()
		"win":
			dowin()
	Flags.effect=""	




func returnBonus(skey):
	Flags.playerStats.bonusStanima=0


func returnhat():
	if Flags.hat=="that":
		Flags.hat=""

func returnbeg():
	if Flags.hat=="beg":
		Flags.hat=""



func missleHit(body):
	body.hit()


func renderPuke():

	var puke=pukeScene.instantiate()
	puke.position.x=($interactive.position.x*-1)+550+(200*(Flags.dir*-1))
	puke.position.y=550
	$interactive.add_child(puke)
	puke.pukehit.connect(pukeHit)

	
func pukeHit(body):
	body.hit()
	
func warpCB(loc):

	warpto(loc)
	var tween = get_tree().create_tween()
	tween.tween_property($player, "modulate", oldmod, .5)



func dorandaction():
	var randaction:=rng.randi_range(0,4)
	if randaction==0:
		Flags.dir=-1
		moveDir(rng.randi_range(1,75),true,Flags.dir,true)
	if randaction==1:
		Flags.dir=1
		moveDir(rng.randi_range(1,75),true,Flags.dir,true)		
	if randaction==2&& canJump==true:
		canJump=false
		Flags.inFight=true
		$player.fight()
		var tween = get_tree().create_tween()
		oldmod = $player.modulate
		tween.tween_property($player, "modulate", oldmod, .65)
		tween.tween_callback(stop_fight)
	if randaction==3 && canJump==true:
		canJump=false
		currSpeed=speed
		speed+=5
		var tween = get_tree().create_tween()
		gy=$player.position.y
		gx=$player.position.x
		$player/jump.play()
		tween.tween_property($player, "position", Vector2(gx,gy-300), .5)
		tween.tween_callback(reset_player)
	if randaction==4 && canJump==true:
		$player.search()
	canrandom=false	
	Flags.dotime(rando,rng.randi_range(1.0,4.0))
		


func rando():
	canrandom=true

func _process(delta):
	
	if Flags.mode!="level":
		return
	
	if Flags.paused==true:
		Flags.resetOnce=true
		return
	if Flags.controlled==true && canrandom==true:
		dorandaction()
		
		
		
	if Input.is_action_just_released("run"):
		stopRun()
	
	
	if Flags.effect!="":
		doEffect()
		
	if stanimaAction==true:
		var rate=Flags.playerStats.stanimaRate
		if Flags.weather=="sun":
			rate=5
		Flags.playerStats.stanima-=rate

	if Flags.playerStats.stanima<1:
		stanimaAction=false
		Flags.exhausted=true
		$player.walkani()
		speed=1
	if stanimaAction==false:
		
		Flags.playerStats.stanima=min(Flags.playerStats.stanima+Flags.playerStats.stanimaRecharge,Flags.playerStats.maxStanima)
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

	if Flags.pukestate==true:
		ani=true
	if !ani && (Flags.inFight==false && Flags.playerSearch==false):		
		$player/AnimatedSprite2D.pause()
	else:
		if !$player/AnimatedSprite2D.is_playing():
			$player/AnimatedSprite2D.play()

	if Flags.mesmerized==true:
		stopRun()
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
		print("what",Flags.interactablenpc)
		if Flags.interactablenpc!=null:
			interact()
			return
		$player.search()

	if Input.is_action_just_pressed("run") && canJump==true && Flags.exhausted==false && Flags.weather!="snow":
		speed=baseSpeed+4		
		stanimaAction=true

	if Input.is_action_just_pressed("enter") && Flags.entered.ready==true:
		if Flags.entered.building.allreadyentered==false:
			$player.enter()
			Flags.entered.active=true
			Flags.paused=true
			Flags.entered.building.allreadyentered=true
			
			Flags.conveniance.oldloc=$locationback.position.x
			ani=true
			var tween=get_tree().create_tween()
			tween.parallel().tween_property($player,"scale",Vector2(0.4,0.4),1.5)
			tween.parallel().tween_property($player,"position",Vector2($player.position.x,350),1.5)
			tween.tween_callback(entered)		


	

	if Flags.pukestate==true:
		$player/AnimatedSprite2D.play()

func interact():
	Flags.paused=true
	Flags.mode=Flags.interactablenpc.mode
	doMode()
	pass

func doMode():
	match Flags.mode:
		"trader":
			$trader.visible=true
			$AudioStreamPlayer.stop()
			$trader.start(self)
	
	
	pass
	
func intreturn():
	$AudioStreamPlayer.play()
	
	
func entered():
	weatheroff()
	speed=1
	warpCB(-99949)
	$player.position.y=0
	Flags.entered.building.start()
	Flags.entered.building.close()

func stopRun():
		if Flags.exhausted==false && canJump==true:
			speed=currSpeed
		else:
			currSpeed=baseSpeed
		$player.walkani()
		stanimaAction=false

func moveDir(base,flip,dir,offS):
	var gospeed=speed
	if Flags.weather=="snow":
		gospeed=max(1,speed/2)
	Flags.l=$locationback.position.x
	$treeholder.position.x+=dir*base*gospeed 
	$treeholder2.position.x+=dir*(base+0.5)*gospeed 
	$treeholder3.position.x+=dir*(base+1.5)*gospeed
	$rocks.position.x+=dir*(base+0.60)*gospeed
	$npcs.position.x+=dir*(base+0.45)*gospeed
	$interactive.position.x+=dir*(base+0.45)*gospeed
	$enemy.position.x+=dir*(base+0.5)*gospeed
	$locationback.position.x+=dir*(base+0.6)*gospeed
	$locationfront.position.x+=dir*(base+0.6)*gospeed
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
		stopRun()
			
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
	var s:="t" 
	if type==1: s="s"
	var name=types[type].name
	var numvariant=types[type].num

	var treenum=rng.randi_range(1,numvariant)
	var ts=assetsScene.instantiate()
	ts.animation=s+str(treenum)
	return ts
	
func _on_enemy_generator_timeout():
	#dospawns()
	pass

func dospawns():
	if Flags.mode!="level":
		#checkspawn in 5 seconds
		Flags.dotime(dospawns,3.0)
		return
		
	if (dangerZone.less*-1>$enemy.position.x):
		if (dangerZone.more*-1<$enemy.position.x):
			
			var upchoice=12

			if $interactive.position.x>-5000 && questDistributed==false:
				upchoice=13
			
			var chance=rng.randi_range(0,upchoice)
			
			var nextSpawn=rng.randf_range(1.5,5.0)
			Flags.dotime(dospawns,nextSpawn)
			
			
			#chance=11 #force spawns here
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
				var expander=expanderScene.instantiate()
				expander.position.x=(($enemy.position.x)*-1)+1400
				expander.position.y=350
				$interactive.add_child(expander)
				return
			if chance<6:
				var enemy=tallmScene.instantiate()
				enemy.position.y=450
				enemy.position.x=(($enemy.position.x)*-1)+1400
				$enemy.add_child(enemy)
				return
			if chance<7:
				var ent=enterScene.instantiate()
				ent.position.x=($locationback.position.x*-1)+1400
				ent.position.y=196
				$locationback.add_child(ent)
				return
			if chance<8:
				$weather.changeweather()
				$weather.position.y=-800
				return
			if chance<9:
				weatheroff()
				return			
			if chance<10:
				var flavor=flavorScene.instantiate()
				flavor.position.x=($npcs.position.x*-1)+1400
				flavor.choose()	
				if flavor.candeploy==true:
					$npcs.add_child(flavor)
				return
			if chance<11:
				var flyer=flyerScene.instantiate()
				flyer.position.x=($enemy.position.x*-1)+1400
				$enemy.add_child(flyer)	
				return
			if chance<12:
				var multi=multiScene.instantiate()
				multi.position.x=($enemy.position.x*-1)+1400
				multi.position.y=400
				$enemy.add_child(multi)	
				return	
				
			if chance<13:
				if questDistributed==false:
					var trash=trashScene.instantiate()
					trash.position.x=(($interactive.position.x)*-1)+1400
					trash.questItem=true
					questDistributed=true
					$interactive.add_child(trash)	
					return
	Flags.dotime(dospawns,3.0)
	#move to own generator
func changeweather():
	$weather.changeweatherforce()
	$weather.position.y=-800

func weatheroff():
	$weather.position.y=0
	Flags.weather=""
	
func _on_rock_body_entered(body):
	$player.hit()


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_missle_hit() -> void:
	pass # Replace with function body.


func _on_tutorial_body_entered(body: Node2D) -> void:
	weatheroff()
	speed=1
	warpto(-16250)

	if Flags.Levels.tutorial.instantiated==false:
		spawn()
		spawntrash(7680,1,1)
		Flags.Levels.tutorial.instantiated=true
	$AudioStreamPlayer.stop()
	$tutorialmusic.play()

func backHome():
	Flags.Levels.tutorial.completed=true
	warpto(0)
	$AudioStreamPlayer.play()
	$tutorialmusic.stop()


func spawn():
	var trash=trashScene.instantiate()
	trash.position.x=(15050*-1)
	trash.setType("fridge")		
	trash.setItem(3,2)	
	$interactive.add_child(trash)	
	return

func dowin():
	Flags.titlescreen="win"
	$player.restart()

func spawntrash(xpos,t,v):
	var trash=trashScene.instantiate()
	trash.position.x=(xpos*-1)
	trash.setItem(t,v)	
	$interactive.add_child(trash)	
	return	

	
func spawnEnemyAt(ep):
	var enemy=enemyScene.instantiate()
	enemy.position.y=500
	enemy.position.x=(ep*-1)
	$enemy.add_child(enemy)
	return

func _on_pailface_body_entered(body: Node2D) -> void:
	spawnEnemyAt(12400)
	pass # Replace with function body.


func _on_exit_body_entered(body: Node2D) -> void:
	backHome()
	pass # Replace with function body.


func _on_backtostart_body_entered(body: Node2D) -> void:
	if body.name=="player":
		backHome()
	pass # Replace with function body.
