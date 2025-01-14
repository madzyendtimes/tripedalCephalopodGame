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

func exit(isdead=false):
	#$music.stop()
	home.exit(isdead)

func start(called):
	#$music.play()
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


func _on_music_finished() -> void:
	#$music.play()
	pass
