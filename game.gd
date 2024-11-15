extends Node2D

var start:PackedScene=load("res://start_screen.tscn");
var level1:PackedScene=load("res://level.tscn")
var startScreen
var level1Scene
var inStart:=true
var instantiated:=false

# Called when the node enters the scene tree for the first time.
func _ready():
	dostart()
	

func dostart():
	startScreen=start.instantiate()
	inStart=true
	add_child(startScreen)		

func restart():
	dostart()
	var tween = get_tree().create_tween()
	tween.tween_property(startScreen, "position", Vector2(0,0), .5)
	tween.tween_callback(removeScene)

func removeScene():
	remove_child(level1Scene)	
	instantiated=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inStart==true:

		if Input.is_action_just_pressed("jump"):
			startScreen.loading()
			inStart=false
			instantiated=true
			level1Scene=level1.instantiate()
			var tween = get_tree().create_tween()
			tween.tween_property(startScreen, "position", Vector2(0,0), .5)
			tween.tween_callback(treeUpdate)

func treeUpdate():
	killStart()
	add_child(level1Scene)
	var tween = get_tree().create_tween()
	tween.tween_property(startScreen, "position", Vector2(0,0), .5)
	tween.tween_callback(killStart)	

func killStart():
	remove_child(startScreen)	
