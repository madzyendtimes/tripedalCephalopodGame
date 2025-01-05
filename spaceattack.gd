extends Node2D
var starScene:PackedScene=load("res://stars.tscn")
var shipScene:PackedScene=load("res://tb_5000.tscn")
var spaceLaser:PackedScene=load("res://spacelaser.tscn")
var metScene:PackedScene=load("res://meteor.tscn")
var speed=5
var xdir=0
var active=false
var spaceobjects=[]


func _ready():
	Flags.vol($laser)
	Flags.vol($gem)
	Flags.vol($music,"music")
	
	#start()


func start():
	addstar()
	$playership.start()
	$playership.position.y=600
	$playership.rotation=0
	active=true
	$music.play()

func _process(delta: float) -> void:
	
#	if Input.is_action_just_pressed("reset"):
#		start()
	
	if !active:
		return
	if $playership.dead:
		$playership.position.y+=10
		if $playership.position.y>1200:
			active=false
			killship()
		return				
	if Input.is_action_pressed("left"):
		xdir=-1
	if Input.is_action_pressed("right"):
		xdir=1
	if Input.is_action_just_pressed("fight"):
		dolaser()	
	$playership.position.x=clamp($playership.position.x+(xdir*speed),-400,1200)	
	

func addgems():
	


	$playership.addgems()
	Flags.pitch($gem)
	$gem.play()

func killship():
	$music.stop()
	Flags.tne.killTimer("addstar","level")
	Flags.mode="level"
	Flags.tne.addEvent("outufo","level",true)
	for i in spaceobjects:
		if i!=null:
			i.queue_free()

func dolaser():
	var laser=spaceLaser.instantiate()
	laser.position.x=$playership.position.x
	laser.position.y=$playership.position.y
	add_child(laser)
	Flags.pitch($laser)
	$laser.play()
	
	
func addstar():
	var star=starScene.instantiate()
	star.position.x=Flags.rng.randi_range(-600,1200)
	star.position.y=-600
	add_child(star)
	if Flags.rng.randi_range(0,100)>75:
		var ship=shipScene.instantiate()
		add_child(ship)
		spaceobjects.append(ship)
				
		if Flags.rng.randi_range(0,100)>75:
			var meteor=metScene.instantiate()
			meteor.position.y=-200
			add_child(meteor)	
	
	Flags.tne.dotime(self,[addstar],Flags.rng.randf_range(.01,.3),"addstar",false,"level")
