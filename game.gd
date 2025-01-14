extends Node2D

var start:PackedScene=load("res://start_screen.tscn");
var level1:PackedScene=load("res://level.tscn")
var startScreen
var level1Scene
var inStart:=true
var instantiated:=false


func _ready():
	Flags.loader()
	Flags.addSounds([
	["mainmusic",$mainmusic,0],
	["tutorial",$tutorialmusic,0],
	["spacemusic",$spacemusic,0],
	["templemusic",$templemusic,0],
	["cryptomusic",$cryptomusic,0],
	["titlemusic",$titlemusic,0],
	["insanitymusic",$insanitymusic,0],
	["witchmusic",$witchmusic,0],
	["bossmusic",$bossmusic,0],
	["strangemusic",$strangemusic,0],
	["jobmusic",$jobmusic,0],
	["gemmusic",$gemmusic,0]
	
	],"music")
	Flags.addSounds([
		["warcry",$warcry,0],
		["lasersound",$lasersound,0],
		["gunshot",$gunshot,2],
		["lilthud",$lilthud,0],
		["alarm",$alarm,0],
		["gemget",$gemget,0],
		["puke",$puke,10],
		["hypno",$hypno,0],
		["jump",$jump,0],
		["splode",$splode,0],
		["hit",$hit,0],
		["die",$die,0],
		["questfound",$questfound,0],
		["trash",$trash,0],
		["punch",$punch,0],
		["search",$search,0],
		["dead",$dead,0],
		["dronehit",$dronehit,0],
		["invalid",$invalid,0],
		["purchase",$purchase,0],
		["multihit",$multihit,0],
		["thud",$thud,0],
		["spaceplayerhit",$spaceplayerhit,0]
		
		],"fx")
	Flags.setvolumes()		
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
