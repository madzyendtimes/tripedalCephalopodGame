extends Node2D
var hp=5
var lastframe=0
var dir=1
var speed=1
var dead=false
var loaded=true
var enemytype={"name":"braino","flying":false,"hp":5,"begchance":0,"speed":1,"pow":2}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$music.volume_db=Flags.options.music
	#Flags.currentmusic=$music
	$hurt/boss.animation="attack"
	$hurt/boss.play()
	change()
	Flags.play("bossmusic","music")
	#$music.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $hurt/boss.animation=="dead":
		return
	if $hurt/boss.animation=="attack":
		$hurt/arm.position.x=-100
		match $hurt/boss.frame:
			1:
				$hurt/arm.position.y=20
			2:
				$hurt/arm.position.y=-70
			3:
				$hurt/arm.position.y=-200
			4:
				$hurt/arm.position.y=-300
			5:
				$hurt/arm.position.y=-500
			0:
				$hurt/arm.position.y=20
	if $hurt/boss.animation=="dazed":
		$hurt/arm.position.x=-100
		$hurt/arm.position.y=-300
	if $hurt/boss.animation=="needle":
		$hurt/arm.position.x=-100
		match $hurt/boss.frame:
			0:
				$hurt/arm.position.y=-200
			2:
				$hurt/arm.position.y=-300
			3:
				$hurt/arm.position.y=-500
			4:
				$hurt/arm.position.y=-500
			5:
				$hurt/arm.position.y=-500
			6:
				$hurt/arm.position.y=-300
			7:
				$hurt/arm.position.y=-300
			8:
				$hurt/arm.position.y=-300
			9:
				$hurt/arm.position.y=-200
			10:
				$hurt/arm.position.y=-200
			_:
				$hurt/arm.position.y=20		

		if $hurt/boss.frame==16 && lastframe!=16:
			if loaded:
				loaded=false
				Flags.tne.addEvent("needle","level",false,{"pos":global_position.x})
				Flags.tne.dotime(self,[loadneedle],1.5,"loadneedle"+str(get_instance_id()),true,"level")			
		lastframe=$hurt/boss.frame

	if $hurt/boss.animation=="walk":
		$hurt/arm.position.x=-100
		$hurt/arm.position.y=20
		position.x+=dir*speed
	pass

func loadneedle():
	loaded=true

func hit(dmg=1):
	if dead:
		return
		Flags.play("multihit")
	hp=Flags.calchits(hp)
	if hp<1:
		$hurt/boss.animation="dead"
		dead=true
		Flags.tne.addEvent("bosskill","level")
		Flags.tne.killTimer("change"+str(get_instance_id()),"level")
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		#$music.stop()
		return
	$hurt/boss.animation="dazed"
	

func change():
	Flags.tne.dotime(self,[change],Flags.rng.randf_range(1.0,5.0),"change"+str(get_instance_id()),true,"level")
	var ch=Flags.rng.randi_range(0,100)
	if ch<50:
		$hurt/boss.animation="attack"
		return
	if ch<75:
		$hurt/boss.animation="needle"
		return
	$hurt/boss.animation="walk"
	
	if Flags.rng.randi_range(0,1)>0:
		dir=1
	else:
		dir=-1

func _on_hurt_body_entered(body: Node2D) -> void:
	if !dead:
		body.hit(enemytype.pow)



func _on_vulnerable_body_entered(body: Node2D) -> void:
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		hit()
		body.hit()
		return
	if Flags.inFight:
		hit()				
