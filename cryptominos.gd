extends Node2D

var rockScene:PackedScene=load("res://cryptominoswscenes/comrock.tscn")
var axeScene:PackedScene=load("res://pickaxe.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for j in range(0,5):

		for i in range(0,20):
			var rocky=rockScene.instantiate()
			rocky.position=Vector2(i*50-208,j*50)
			$playarea.add_child(rocky)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func start():
	
	Flags.entered.active=true
	Flags.paused=true
	var axe=axeScene.instantiate()
	$complayer.position.x=200
	axe.position.x=$complayer.position.x
	axe.position.y=$complayer.position.y-100
	add_child(axe)
	axe.name="pickaxe"
	axe.start()
