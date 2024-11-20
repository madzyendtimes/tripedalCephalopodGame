extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$loading.visible=false
	
	if Flags.titlescreen=="win":
		$Title.animation="win"
	else:
		$Title.animation="title"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loading():
	$loading.visible=true
	Flags.titlescreen="title"
