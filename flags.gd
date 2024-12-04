extends Node

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
var interactablenpc=""
var Levels:={"tutorial":{"instantiated":false,"complete":false},"cityOutskirts":{"instantiated":true,"complete":false}}
var megaStats:={"gems":0}
var entered:={
	"ready":false,
	"active":false,
	"building":"",
	"type":""
	}

var Quests:={
		"legless":
			{"completed":false,
			"objective":[2,1],
			"reward":{"method":"permaboost","vars":[1,"maxHealth"],"text":"You found my legs! Let me teach you the ancient zombie art of extra health"}
			}
		}
#var playerStats:={"health":1,"maxHealth":3,"stanima":600,"maxStanima":600,"stanimaRate":1,"speed":1,"maxSpeed":1,"power":1,"maxPower":1}
var playerStats=stats.new()
var credit:=false
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
	]},
	{"type":"quest","varients":
		[{"name":"legs","effect":"quest","consumable":false,"swap":{}},
		{"name":"specimen","effect":"quest","consumable":false,"swap":{}}
	]}]
var flavornpc:={"npc":[
	{"name":"fanguymanly","deployed":false},
	{"name":"princessoccula","deployed":false},
	{"name":"win3","deployed":false}
]}
var paused:=false
var resetOnce:=false
var selectedItem:=-1
var exhausted=false
var pukestate=false
var effect=""
var warploc=2950
var hat=""
var mesmerized=false
var controlled=false
var types=[{"name":"items/food/food","num":4,"type":"food"},{"name":"items/scrap/scrap","num":6,"type":"scrap"},{"name":"items/fancy/fancy","num":2,"type":"fancy"},{"name":"items/quest/item","num":1,"type":"quest"}]
var conveniance={"oldloc":0}
var horror:=false
var radiation:=false

func reset():
	controlled=false
	radiation=false
	flavornpc={"npc":[
	{"name":"fanguymanly","deployed":false},
	{"name":"princessoccula","deployed":false},
	{"name":"win3","deployed":false}
	]}
	credit=false
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
	#playerStats={"health":playerStats.maxHealth,"maxHealth":playerStats.maxHealth,"stanima":playerStats.maxStanima,"maxStanima":playerStats.maxStanima,"stanimaRate":1,"speed":playerStats.maxSpeed,"maxSpeed":1,"power":playerStats.maxPower,"maxPower":1}
	playerSearch=false
	inSearch=false
	paused=false
	conveniance={"oldloc":0}
	
	
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
