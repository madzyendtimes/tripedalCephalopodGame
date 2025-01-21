extends Node2D

var start:PackedScene=load("res://start_screen.tscn");
var level1:PackedScene=load("res://level.tscn")
var startScreen
var level1Scene
var inStart:=true
var instantiated:=false


func _ready():
	$acheivement.visible=false
	Flags.loader()
	Flags.uberstatsloader()
	Flags.addSounds([
	["mainmusic",$mainmusic,0,0],
	["tutorial",$tutorialmusic,0,0],
	["spacemusic",$spacemusic,0,0],
	["templemusic",$templemusic,0,0],
	["cryptomusic",$cryptomusic,0,0],
	["titlemusic",$titlemusic,0,0],
	["insanitymusic",$insanitymusic,0,0],
	["witchmusic",$witchmusic,0,0],
	["bossmusic",$bossmusic,0,0],
	["strangemusic",$strangemusic,0,0],
	["jobmusic",$jobmusic,0,0],
	["gemmusic",$gemmusic,0,0],
	["gameover",$gameover,0,0],
	["win",$winmusic,0,0]
	],"music")
	Flags.addSounds([
		["warcry",$warcry,0,.05],
		["lasersound",$lasersound,0,.05],
		["gunshot",$gunshot,10,.05],
		["lilthud",$lilthud,5,.05],
		["alarm",$alarm,10,0],
		["gemget",$gemget,0,.05],
		["puke",$puke,10,.05],
		["hypno",$hypno,0,0],
		["jump",$jump,0,.05],
		["splode",$splode,0,.05],
		["hit",$hit,0,.05],
		["die",$die,0,0],
		["questfound",$questfound,0,0],
		["trash",$trash,0,.05],
		["punch",$punch,0,.05],
		["search",$search,0,.05],
		["dead",$dead,0,.05],
		["dronehit",$dronehit,0,.05],
		["invalid",$invalid,0,.05],
		["purchase",$purchase,10,.05],
		["multihit",$multihit,0,.05],
		["thud",$thud,0,.05],
		["spaceplayerhit",$spaceplayerhit,0,.05],
		["pickaxe",$pickaxe,0,.05],
		["offering",$offering,0,.05],
		["scary",$scary,0,.05],
		["warp",$warp,0,.05],
		["weathermachine",$weathermachine,0,.05],
		],"fx")
	Flags.setvolumes()		
	dostart()

func hideac():
	$acheivement.visible=false

func _process(delta: float) -> void:
	var ev=Flags.tne.consumeEvent("main")
	if ev != null:
		match ev.name:
			"acheivement":
				print("acheivement",ev.param)
				$acheivement.visible=true
				$acheivement/Label.text="acheivement:"+ev.param.obj.name+"\n"+ev.param.obj.description+"\n"+str(ev.param.obj.points)+" points"
				if !Flags.uberStats.acheivements.has("total"):
					Flags.uberStats.acheivements["total"]=0
				Flags.uberStats.acheivements["total"]+=ev.param.obj.points
				Flags.tne.dotime(self,[hideac],3.0,"hideacheivement",true,"main")

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
