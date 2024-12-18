extends Node2D
var home=self
var rockScene:PackedScene=load("res://cryptominoswscenes/comrock.tscn")
var axeScene:PackedScene=load("res://pickaxe.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music.volume_db=Flags.options.music
	for j in range(0,5):

		for i in range(0,20):
			var rocky=rockScene.instantiate()
			rocky.position=Vector2(i*50-208,j*50)
			$playarea.add_child(rocky)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Flags.cryptoeffects:
		"exit":
			exit()
	pass

func exit():
	$music.stop()
	home.exit()

func start(called):
	$music.play()
	home=called
	print("cryptostarted")
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
	$music.play()
	pass # Replace with function body.
