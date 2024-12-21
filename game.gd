extends Node2D

var start:PackedScene=load("res://start_screen.tscn");
var level1:PackedScene=load("res://level.tscn")
var startScreen
var level1Scene
var inStart:=true
var instantiated:=false


func _ready():
	Flags.loader()
	dostart()

	

func dostart():
	startScreen=start.instantiate()
	inStart=true
	add_child(startScreen)
	startScreen.start(self)	

func restart():
	dostart()
	Flags.tne.dotime(self,[removeScene],.1,"removeScene",true)

func removeScene():
	remove_child(level1Scene)	
	instantiated=false



func playgame():
	inStart=false
	instantiated=true
	level1Scene=level1.instantiate()

	Flags.tne.dotime(self,[treeUpdate],.5,"treeupdate",true)

func treeUpdate():
	killStart()
	add_child(level1Scene)

	Flags.tne.dotime(self,[killStart],.5,"killstart",true)


func killStart():
	remove_child(startScreen)	
