extends Node2D
var home=self
var rockScene:PackedScene=load("res://cryptominoswscenes/comrock.tscn")
var axeScene:PackedScene=load("res://pickaxe.tscn")

func _ready() -> void:
	#$music.volume_db=Flags.options.music
	for j in range(0,5):
		for i in range(0,20):
			var rocky=rockScene.instantiate()
			rocky.position=Vector2(i*50-208,j*50)
			$playarea.add_child(rocky)

func _process(delta: float) -> void:
	
	var ce=Flags.tne.consumeEvent("cryptominos")
	if ce!=null:
		match ce.name:
			"exit":
				exit()
			"dead":
				exit(true)
			"hit":
				stat("-","health",ce.param.dmg)	
			"gem":
				stat("+","gem",ce.param.gems)
			"pickaxe":
				var axe=axeScene.instantiate()

				axe.position.x=$complayer.position.x
				axe.position.y=$complayer.position.y-100
				add_child(axe)
				axe.name="pickaxe"
				axe.start()
				
			
func exit(isdead=false):
	home.exit(isdead)

func start(called):
	Flags.play("cryptomusic","music")
	home=called
	Flags.mode="cryptominos"
	Flags.entered.active=true
	Flags.paused=true
	var axe=axeScene.instantiate()
	$complayer.position.x=200
	axe.position.x=$complayer.position.x
	axe.position.y=$complayer.position.y-100
	add_child(axe)
	axe.name="pickaxe"
	axe.start()
	Flags.recordAcheivement("enteredcryptominos")

func stat(mth,ptype,amount):
	$complayer/stat.visible=true
	var showamount=str(amount)
	if amount==0:
		showamount=""
	$complayer/stat/Label.text=mth+" "+showamount
	$complayer/stat/AnimatedSprite2D.animation=ptype

	Flags.tne.dotime(self,[unstat],1.5,"unstat",true,"cryptominos")


func unstat():
	$complayer/stat.visible=false
	pass
