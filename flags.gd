extends Node

var treeScene:PackedScene=load("res://tree.tscn")
var enemyScene:PackedScene=load("res://groundling.tscn")
var rockScene:PackedScene=load("res://rock.tscn")
var trashScene:PackedScene=load("res://interact.tscn")
var warpScene:PackedScene=load("res://warp.tscn")
var tvScene:PackedScene=load("res://tv.tscn")
var missleScene:PackedScene=load("res://missle.tscn")
var pukeScene:PackedScene=load("res://puke.tscn")
var expanderScene:PackedScene=load("res://expander.tscn")
var tallmScene:PackedScene=load("res://monster_tall.tscn")
var welcomeScene:PackedScene=load("res://welcome_center.tscn")
var assetsScene:PackedScene=load("res://assets.tscn")
var enterScene:PackedScene=load("res://enterable.tscn")
var flavorScene:PackedScene=load("res://flavornpc.tscn")
var flyerScene:PackedScene=load("res://flyer.tscn")
var multiScene:PackedScene=load("res://multistage.tscn")


var options={"controls":"controller","music":-10,"fx":-10,"randomizeDistribution":false,"seed":{"active":false,"value":"fun"},"startfresh":false,"graphics":"high"}
var defoptions={"controls":"controller","music":-10,"fx":-10,"randomizeDistribution":false,"seed":{"active":false,"value":"fun"},"startfresh":false,"graphics":"high"}
var controlScheme="controller"
var freshstart=false
var weather=""
const stats=preload("res://playerstats.gd")
const eq=preload("res://event_q.gd")
var l=0
var playerposition
var playerscale
var titlescreen:="title"
var canJump:=true
var inFight:=false
var playerDead:=false
var playerInventory:=[]
var interactablenpc=null

var defaultStats:={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"rizz":0,"capRizz":10,"smarts":0,"capSmarts":10,
"inventory":[],"inventorycapacity":0,"credit":false,
"toughness":0,"capToughness":5,
"karma":0,
"spinattack":false,
"dizres":1.5,
"extraJump":1,"capExtraJump":5,
"deathgifts":false,
"attackmode":{"tentacle":true,"gun":false},
"transmute":false,
"liltrip":false
}
var uberStats:={"collectables":[],"kills":{"total":0},"deaths":{"total":0},"specials":{},"items":{},"purchases":{},"npcs":{},"acheivements":{"total":0}
}
var defaultUberStats={
		"collectables":[],"kills":{"total":0},"deaths":{"total":0},"specials":{},"items":{},"purchases":{},"npcs":{},"acheivements":{"total":0}
	}
var Levels:={"tutorial":{"instantiated":false,"complete":false},"cityOutskirts":{"instantiated":true,"complete":false}}
var megaStats:={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"rizz":0,"capRizz":10,"smarts":0,"capSmarts":10,
"inventory":[],"inventorycapacity":0,"credit":false,
"toughness":0,"capToughness":5,
"karma":0,
"spinattack":false,
"dizres":1.5,
"extraJump":1,"capExtraJump":5,
"deathgifts":false,
"attackmode":{"tentacle":true,"gun":false},
"transmute":false,
"liltrip":false
}
var entered:={
	"ready":false,
	"active":false,
	"building":"",
	"type":""
	}
#need to add sludgebutt and add raandom extra npcQuests for gems 
var Quests:={
		"legless":
			{"completed":false,
			"objective":[3,1],
			"reward":{"method":"permaboost","vars":[1,"maxHealth"],"text":"You found my legs! Let me teach you the ancient zombie art of extra health"}
			}
		}
#var playerStats:={"health":1,"maxHealth":3,"stanima":600,"maxStanima":600,"stanimaRate":1,"speed":1,"maxSpeed":1,"power":1,"maxPower":1}

var tne=eq.new()
var playerStats=stats.new()#playerstats references tne always place after instatiating eq

var credit=megaStats.credit
var baseStats=playerStats
var bonus:={"stanima":0,"health":0,"power":0,"speed":0,"rizz":0,"smarts":0}
var playerSearch:=false
var inSearch:=false
var inJump:=false
var inCrouch:=false
var dir:=1
var itemMap:=[
	{"type":"food","varients":[
		{"name":"old pizza","effect":"restorehp","consumable":true,"swap":{}},
		{"name":"noodles... or worms!","effect":"puke|restorehp","consumable":true,"swap":{}},
		{"name":"suspect sandwitch","effect":"puke","consumable":true,"swap":{}},
		{"name":"full soda","effect":"stanima","consumable":true,"swap":{"type":1,"varient":2}}
	]},
	{"type":"scrap","varients":
		[{"name":"tin foil hat","effect":"that","consumable":true,"swap":{}},
		{"name":"crushed soda","effect":"kick","consumable":true,"swap":{}},
		{"name":"broken mirror","effect":"warp","consumable":true,"swap":{}},
		{"name":"begging board","effect":"beg","consumable":true,"swap":{}},
		{"name":"horror movie","effect":"horror","consumable":true,"swap":{}},
		{"name":"plutonium","effect":"radiation","consumable":true,"swap":{}}
	]},
	{"type":"fancy","varients":
		[{"name":"gold card","effect":"spendingspree","consumable":true,"swap":{}},
		{"name":"gem","effect":"getgems","consumable":true,"swap":{}},
		{"name":"weather machine","effect":"changeweather","consumable":true,"swap":{}},
	]},

	{"type":"quest","varients":
		[{"name":"legs","effect":"quest","consumable":false,"swap":{}},
		{"name":"specimen","effect":"quest","consumable":false,"swap":{}},
		{"name":"rejectionletter","effect":"quest","consumable":false,"swap":{}}
	]},
		{"type":"collectable","varients":
		[{"name":"the mime who cried","effect":"combustable","consumable":true,"swap":{}},
		{"name":"the mime who cried","effect":"combustable","consumable":true,"swap":{}},
		{"name":"40 devils","effect":"combustable","consumable":true,"swap":{}},
		{"name":"cave of the nylon web","effect":"combustable","consumable":true,"swap":{}},
		{"name":"megaponpopulos","effect":"combustable","consumable":true,"swap":{}},
		{"name":"batman slaps dracula","effect":"combustable","consumable":true,"swap":{}},
		{"name":"london during midnight","effect":"combustable","consumable":true,"swap":{}},
	]}
	]
var flavornpc:={"npc":[{"name":"fanguymanly","deployed":false,"quest":{}},
	{"name":"princessoccula","deployed":false,"quest":{}},
	{"name":"win3","deployed":false,"quest":{}},
	{"name":"infotammy","deployed":false,"quest":{}},
	{"name":"piper","deployed":false,"quest":{}},
	{"name":"emmaemo","deployed":false,"quest":{"requirements":[{"type":3,"num":3}],"reward":"gun"}}
]}
var enemytypes:={
	"ufo":{"type":"vehicle","weak":"laser","strong":"physical","immune":"","name":"ufo","flying":true,"hp":4,"begchance":0,"speed":5,"pow":3,"variety":""},
	"knifeulator":{"type":"trap","weak":"balistic","strong":"","immune":"tentacle","name":"knifeulator","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1,"variety":""},
	"plaugetestor":{"type":"humanoid","weak":"fire","strong":"poison","immune":"","name":"plaugetestor","flying":false,"hp":2,"begchance":42,"speed":1.8,"pow":1,"variety":""},
	"braino":{"type":"zombie","weak":"","strong":"","immune":"","name":"braino","flying":false,"hp":5,"begchance":0,"speed":1,"pow":2,"variety":""},
	"gravestone":{"type":"haunted","weak":"","strong":"fire","immune":"","name":"gravestone","flying":false,"hp":5,"begchance":0,"speed":0,"pow":0,"variety":""},
	"ghost":{"type":"ephemeral","weak":"magic","strong":"physical","immune":"tentacle","name":"ghost","flying":false,"hp":5000,"begchance":0,"speed":3,"pow":1,"variety":""},
	"gemmonster":{"type":"magical","weak":"","strong":"","immune":"","name":"gemmonster","flying":false,"hp":1,"begchance":100,"speed":3,"pow":1,"variety":""},
	"goop baby":{"type":"humanoid","weak":"","strong":"","immune":"","name":"goop baby","flying":false,"hp":3,"begchance":75,"speed":2.5,"pow":2,"variety":""},
	"bird":{"type":"flying","weak":"","strong":"","immune":"","name":"bird","flying":true,"hp":1,"begchance":40,"speed":2.5,"pow":1,"variety":""},
	"diaper tooth":{"type":"humanoid","weak":"","strong":"","immune":"","name":"diaper tooth","flying":false,"hp":2,"begchance":50,"speed":1.8,"pow":1,"variety":""},
	"saw":{"type":"trap","weak":"ballistic","strong":"physical","immune":"tentacle","name":"saw","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1,"variety":""},
	"expander":{"type":"trap","weak":"ballistic","strong":"","immune":"tentacle","name":"expander","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1,"variety":""},
	"rock":{"type":"rock","weak":"ballistic","strong":"physical","immune":"tentacle","name":"rock","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1,"variety":""},
	"groundling":{"type":"zombie","weak":"fire","strong":"","immune":"","name":"groundling","flying":false,"hp":1,"begchance":25,"speed":.75,"pow":1,"variety":""},
	"eggmissle":{"type":"missle","weak":"","strong":"","immune":"all","name":"eggmissle","flying":false,"hp":1,"begchance":0,"speed":2,"pow":1,"variety":""},
	"needle":{"type":"missle","weak":"","strong":"","immune":"all","name":"needle","flying":false,"hp":1,"begchance":0,"speed":1,"pow":1,"variety":""},
	"laser":{"type":"missle","weak":"","strong":"","immune":"all","name":"laser","flying":false,"hp":1,"begchance":0,"speed":1,"pow":2,"variety":""}
}
var varietymap:={"rock1":"stench jelly","rock2":"watcher's rock","rock3":"spite knocker"}
var paused:=false
var mode:="level"
var selectedItem:=-1
var exhausted=false
var pukestate=false
var warploc=2950
var hat=""
var mesmerized=false
var controlled=false
var types=[{"name":"items/food/food","num":4,"type":"food"},{"name":"items/scrap/scrap","num":6,"type":"scrap"},{"name":"items/fancy/fancy","num":3,"type":"fancy"},{"name":"items/quest/item","num":1,"type":"quest"},{"name":"items/collectable/collectable","num":7,"type":"collectable"}]
var conveniance={"oldloc":0}
var horror:=false
var radiation:=false
var questpc:=[
	{"name":"epsilon","mode":"jobboard"},
	{"name":"gemna","mode":"trader"}
]

var		specialnpc=[
		{"name":"epsilon frank","deployed":false,"code":"e"},
		{"name":"gemna","deployed":false,"code":"e"}
		]
var playerHits=1
var percentageMap=[
10, #trash
10, #rock
9, #groundling
4, #tv
9, #expander
9, #tall monster (diapertooth)
9, #minigame
5, #weather effects
5, #fair weather
5, #flavor npcs
8,#8, #flying enemy
7, #multistage enemy
3, #gemmonster
3, #hoarde
9, #gravestone
9, #special npc
1,#boss
5,#gas
10, #saw
8, #knifulator
5,#ufo
5 #quest
]
#var percentageMap=[0,0,0,0,0,0,50,0,0,0,0,0,50,0,0] #enterable
var percentageAgg=100
var eventQ=[]
var spinned=false
var confused=false
var special=""
var rng=RandomNumberGenerator.new()
var witchevents=""
var fightmode=""
var questDistributed=false
var vehicle=null
var currentmusic=null
var wasufo=false
var env=[]
var amode=[]
var petmove=true
var sounds={"music":{},"fx":{}}

var acheivements={
	"totalkills":{"criteria":func criteriamet(aobj): return aobj.value>0,"description":"Kill 1 enemy total","points":10,"name":"You choose murder!"}
	
	}


func weatheroff():
	$weather.position.y=0
	Flags.weather=""

func addSounds(asounds,ptype="fx"):
	for i in asounds:
		sounds[ptype][i[0]]={"aud":i[1],"vol":i[2],"pitch":i[3]}
		if ptype=="music":
			i[1].finished.connect(i[1].play)

func setvolumes():
	for i in sounds.music:
		sounds.music[i].aud.volume_db=options.music+sounds.music[i].vol
	for i in sounds.fx:
		sounds.fx[i].aud.volume_db=options.fx+sounds.fx[i].vol

func stopthemusic():
	if currentmusic!=null&&(sounds.music.get(currentmusic) != null):
		sounds.music[currentmusic].aud.stop()
		
func play(key,type="fx"):

	if sounds[type][key]!=null:
		if sounds[type][key].pitch>0:
			pitch(sounds[type][key].aud,sounds[type][key].pitch)
		if type=="music":
			stopthemusic()
			currentmusic=key
		sounds[type][key].aud.play()

		

func vol(aud,atype="fx",added=0):
	if atype=="fx":
		aud.volume_db=options.fx+added
	else:
		aud.volume_db=options.music+added
		
func pitch(aud,pch=0):	
	aud.pitch_scale=rng.randf_range(1-pch,1+pch)

func reset():
	amode=[]
	wasufo=false
	vehicle=null
	spinned=false
	confused=false
	special=""
	inJump=false
	inCrouch=false
	percentageAgg=0
	for i in percentageMap:
		percentageAgg+=i
	controlled=false
	radiation=false
	flavornpc={"npc":[
	{"name":"fanguymanly","deployed":false,"scale":-1,"ypos":0,"quest":{}},
	{"name":"princessoccula","deployed":false,"scale":-1,"ypos":0,"quest":{}},
	{"name":"win3","deployed":false,"scale":-1,"ypos":0,"quest":{}},
	{"name":"infotammy","deployed":false,"scale":-1,"ypos":0,"quest":{}},
	{"name":"piper","deployed":false,"scale":-1,"ypos":0,"quest":{}},
	{"name":"emmaemo","deployed":false,"scale":1.9,"ypos":-100,"quest":{"requirements":[{"type":3,"num":3}],"reward":"gun"}}
	]}
	specialnpc=[
		{"name":"epsilon frank","deployed":false,"code":"e","scene":"jobboard","ypos":-200},
		{"name":"gemna","deployed":false,"code":"g","scene":"trader","ypos":0}
		]
	fightmode=""
	mesmerized=false
	hat=""
	horror=false
	warploc=2950
	pukestate=false
	exhausted=false
	selectedItem=-1
	dir=1
	canJump=true
	inFight=false
	playerDead=false
	playerInventory=[]
	playerStats=stats.new()
	playerSearch=false
	inSearch=false
	paused=false
	conveniance={"oldloc":0}
	mode="level"
	refreshPlayer()
	credit=megaStats.credit
	playerHits=megaStats.power
	interactablenpc=null
	env=[]
	petmove=true
#	defaultuberstats()

func addEnv(scenes):
	for i in scenes:
		env.append({"scene":i[0],"y":i[0].position.y,"speed":i[1]})


func calchits(hp):
	print("playerhits:",playerHits)
	if special=="ufo":
		return 0
	var tmphit=hp
	if playerHits>0:
		hp-=playerHits
		playerHits=max(0,playerHits-tmphit)
	print("hp=",hp)
	return hp

#subtrcts enemy power by toughness with a max reduction of 1
func calcdmg(pow):
	print("calc damage with power ",pow)
	print("toughness ",Flags.megaStats.toughness)
	var tmp=playerStats.toughness
	var dmg=tmp-pow
	dmg=max(dmg,1)
	print("resluting damage= ",dmg)
	return dmg

func beg(begchance):
	if rng.randi_range(0,100)<(begchance+(playerStats.rizz*10)):
		tne.addEvent("addgems","level")
		return true
	return false
	
func deathgifts():
	if !megaStats.deathgifts:
		return
	var gift=rng.randi_range(0,100)
	if gift<25:
		playerStats.health+=1
		return
	if gift<50:
		tne.addEvent("addgems","level")
		return
	if gift<75:
		playerStats.stanima=playerStats.maxStanima
		return
	var gtype=Flags.rng.randi_range(0,2)
	var numvariant=types[gtype].num
	var treenum=rng.randi_range(1,numvariant)
	var gitem=addToInventory(gtype,numvariant)
	tne.addEvent("inventoryAcquired","level",false,{"item":gitem})
	
	
func addToInventory(type,numvarient):
	var name=types[type].name
	var treenum=numvarient
	
	var istr="res://"+name+"text"+str(treenum)+".PNG"
	var image = Image.load_from_file(istr)
	var texture = ImageTexture.create_from_image(image)
	var invitem={"type":type,
		"item":treenum,
		"img":istr,
		"imgt":texture,
		"effect":itemMap[type].varients[max(0,treenum-1)].effect,
		"consumable":itemMap[type].varients[max(0,treenum-1)].consumable,
		"swap":itemMap[type].varients[max(0,treenum-1)].swap,
		"name":itemMap[type].varients[max(0,treenum-1)].name,
		"bequeathed":false
		}

	playerInventory.append(invitem)
	return invitem


func refreshoptions():
	controlScheme=options.controls
	
func saveoptions():
	var save_file = FileAccess.open("user://tcoptionsv2.save", FileAccess.WRITE)
	var json_string = JSON.stringify(options)
	save_file.store_line(json_string)
	refreshoptions()

func defaultoptions():
	print("poroblem with options file, loading defaults")
	options=defoptions

	

func loadoptions():

	if not FileAccess.file_exists("user://tcoptionsv2.save"):
		defaultoptions()
		return
	var save_file = FileAccess.open("user://tcoptionsv2.save", FileAccess.READ)

	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("can't parse options")
			defaultoptions()
			continue

		options=json.data
		refreshoptions()
		#print(options)



func saveuberstats():

	var save_file = FileAccess.open("user://tcvuber1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(uberStats)
	save_file.store_line(json_string)

func recordAcheivement(ament,crit={"value":0}):
	if acheivements[ament].criteria.call(crit):
		if !uberStats.acheivements.has(ament):
			uberStats.acheivements[ament]=true
			tne.addEvent("acheivement","main",false,{"type":ament,"obj":acheivements[ament]})

func recordDeath(enemy):
	if !uberStats.deaths.has(enemy.type):
		uberStats.deaths[enemy.type]={}
	uberStats.deaths.total+=1
	var name=enemy.name
	if enemy.variety!="":
		name=enemy.variety
	if !uberStats.deaths[enemy.type].has("total"):
		uberStats.deaths[enemy.type]["total"]=0
	uberStats.deaths[enemy.type]["total"]+=1
	if uberStats.deaths[enemy.type].has(name):
		uberStats.deaths[enemy.type][name]+=1
	else:
		uberStats.deaths[enemy.type][name]=1
	saveuberstats()
	
func recordKill(enemy):

	uberStats.kills.total+=1
	recordAcheivement("totalkills",{"value":uberStats.kills.total})
	if !uberStats.kills.has(enemy.type):
		uberStats.kills[enemy.type]={}
	var name=enemy.name
	if enemy.variety!="":
		name=enemy.variety
	if !uberStats.kills[enemy.type].has("total"):
		uberStats.kills[enemy.type]["total"]=0
	uberStats.kills[enemy.type]["total"]+=1
	if uberStats.kills[enemy.type].has(name):
		uberStats.kills[enemy.type][name]+=1
	else:
		uberStats.kills[enemy.type][name]=1
	saveuberstats()

func save():
	var save_file = FileAccess.open("user://tcv1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(megaStats)
	save_file.store_line(json_string)

	
func defaultuberstats():
	print("problem with uberstats, loading defaults")
	uberStats={
		"collectables":[],"kills":{"total":0},"deaths":{"total":0},"specials":{},"items":{},"purchases":{},"npcs":{},"acheivements":{"total":0}
	}

func uberstatsloader():
	if not FileAccess.file_exists("user://tcvuber1.save")|| freshstart==true:
		defaultuberstats()
		return

	var save_file = FileAccess.open("user://tcvuber1.save", FileAccess.READ)

	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			defaultuberstats()
			continue

		uberStats=json.data
		for i in defaultUberStats.keys():
			if !uberStats.has(i):
				uberStats[i]=defaultUberStats[i]

	print(uberStats)


func defaultmegastats():
	print("problem with megastats, loading defaults")
	megaStats={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"rizz":0,"capRizz":10,"smarts":0,"capSmarts":10,"inventory":[],"inventorycapacity":0,"credit":false,"spinattack":false,"dizres":1.5,
	"toughness":0,"capToughness":5,
	"karma":0,
	"extraJump":1,"capExtraJump":5,
	"deathgifts":false,
	"attackmode":{"tentacle":true,"gun":false},
	"transmute":false,
	"liltrip":false
	}

func loader():
	if not FileAccess.file_exists("user://tcv1.save")|| freshstart==true:
		defaultmegastats()
		return

	var save_file = FileAccess.open("user://tcv1.save", FileAccess.READ)

	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			defaultmegastats()
			continue

		megaStats=json.data
		for i in defaultStats.keys():
			if !megaStats.has(i):
				megaStats[i]=defaultStats[i]
		for i in megaStats.attackmode.keys():
			if !megaStats.attackmode.has(i):
				megaStats.attackmode[i]=defaultStats.attackmode[i]
		refreshPlayer()
		
func refreshPlayer():
	playerStats.actual={
		"health":megaStats.health,
		"stanima":megaStats.stanima+0,
		"power":megaStats.power,
		"speed":megaStats.speed,
		"stanimaRate":megaStats.stanimaRate,
		"stanimaRecharge":megaStats.stanimaRecharge,
		"rizz":megaStats.rizz,
		"smarts":megaStats.smarts,
		"toughness":megaStats.toughness,
		"karma":megaStats.karma
	}
	playerStats.maximum={
		"health":megaStats.health,
		"stanima":megaStats.stanima+0,
		"power":megaStats.power,
		"speed":megaStats.speed,
		"stanimaRate":megaStats.stanimaRate,
		"stanimaRecharge":megaStats.stanimaRecharge,
		"rizz":megaStats.rizz,
		"smarts":megaStats.smarts,
		"toughness":megaStats.toughness,
		"karma":megaStats.karma
	}

	credit=megaStats.credit
	#translate old saves
	if megaStats.attackmode.get("fist") != null:
		megaStats.attackmode.erase("fist")
		megaStats.attackmode["tentacle"]=true
		
func clearnode(danode):
	var removenode=danode.get_children()
	for i in removenode:
		i.queue_free()
