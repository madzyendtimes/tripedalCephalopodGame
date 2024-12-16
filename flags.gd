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




var freshstart=false
var weather=""
const stats=preload("res://playerstats.gd")
var l=0
var playerposition
var playerscale
var titlescreen:="title"
var canJump:=true
var inFight:=false
var playerDead:=false
var playerInventory:=[]
var interactablenpc=null
var defaultStats:={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"inventory":[],"inventorycapacity":0,"credit":false}
var Levels:={"tutorial":{"instantiated":false,"complete":false},"cityOutskirts":{"instantiated":true,"complete":false}}
var megaStats:={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"inventory":[],"inventorycapacity":0,"credit":false}
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
var playerStats=stats.new()

var credit=megaStats.credit
var baseStats=playerStats
var bonus:={"stanima":0,"health":0,"power":0,"speed":0}
var playerSearch:=false
var inSearch:=false
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
		{"name":"specimen","effect":"quest","consumable":false,"swap":{}}
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
var flavornpc:={"npc":[
	{"name":"fanguymanly","deployed":false},
	{"name":"princessoccula","deployed":false},
	{"name":"win3","deployed":false}
]}
var paused:=false
var mode:="level"
var selectedItem:=-1
var exhausted=false
var pukestate=false
var effect=""
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

var percentageMap=[10,10,10,10,10,10,10,5,5,3,5,5,2,2,3]
#var percentageMap=[0,0,0,0,0,0,50,0,0,0,0,0,50,0,0] #enterable
var percentageAgg=100



var rng=RandomNumberGenerator.new()
var witchevents=""
var cryptoeffects=""

var questDistributed=false

func weatheroff():
	$weather.position.y=0
	Flags.weather=""


func reset():
	percentageAgg=0
	for i in percentageMap:
		percentageAgg+=i
	controlled=false
	radiation=false
	flavornpc={"npc":[
	{"name":"fanguymanly","deployed":false},
	{"name":"princessoccula","deployed":false},
	{"name":"win3","deployed":false},
	{"name":"infotammy","deployed":false},
	{"name":"piper","deployed":false}
	]}
	mesmerized=false
	hat=""
	horror=false
	warploc=2950
	effect=""
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
	
func addToInventory(type,numvarient):
	print("addtoinventory")
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
		"swap":itemMap[type].varients[max(0,treenum-1)].swap
		}
	print(invitem)
	playerInventory.append(invitem)


func dotime(timefunc,ntime):
	var gt:Timer=Timer.new()
	add_child(gt)
	gt.wait_time=ntime
	gt.one_shot=true			
	gt.timeout.connect(timefunc)
	gt.start()
	
	
func save():
	print(megaStats)
	var save_file = FileAccess.open("user://tcv1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(megaStats)
	save_file.store_line(json_string)
	print(megaStats)
func defaultmegastats():
	megaStats={"gems":99,"health":3,"capHealth":20,"speed":1,"capSpeed":10,"power":1,"capPower":10,"stanima":600,"capStanima":1200,"stanimaRate":1,"capStanimaRate":10,"stanimaRecharge":1,"capStanimaRecharge":20,"inventory":[],"inventorycapacity":0,"credit":false}
	
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
		refreshPlayer()
		
func refreshPlayer():
	playerStats.actual={
		"health":megaStats.health,
		"stanima":megaStats.stanima+0,
		"power":megaStats.power,
		"speed":megaStats.speed,
		"stanimaRate":megaStats.stanimaRate,
		"stanimaRecharge":megaStats.stanimaRecharge
	}
	playerStats.maximum={
		"health":megaStats.health,
		"stanima":megaStats.stanima+0,
		"power":megaStats.power,
		"speed":megaStats.speed,
		"stanimaRate":megaStats.stanimaRate,
		"stanimaRecharge":megaStats.stanimaRecharge
	}
	#print(megaStats)
	credit=megaStats.credit		
		
func clearnode(danode):
	var removenode=danode.get_children()
	for i in removenode:
		i.queue_free()
