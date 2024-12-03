extends Node2D
var candeploy:=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose():
	var num=Flags.flavornpc.npc.size()
	var rng=RandomNumberGenerator.new()
	var choice=rng.randi_range(0,num-1)
	if Flags.flavornpc.npc[choice].deployed==false:
		Flags.flavornpc.npc[choice].deployed=true
		$npc.animation=Flags.flavornpc.npc[choice].name
		$text.animation=Flags.flavornpc.npc[choice].name+"text"
		$npc.play()
	else:
		candeploy=false
