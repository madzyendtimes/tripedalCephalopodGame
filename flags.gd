extends Node

var canJump:=true
var inFight:=false
var playerDead:=false
var playerInventory:=[]
var playerStats:={"health":1,"maxHealth":3,"stanima":600,"maxStanima":600,"stanimaRate":1,"speed":1,"maxSpeed":1,"power":1,"maxPower":1}
var baseStats=playerStats
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
		{"name":"begging board","effect":"beg","consumable":true,"swap":{}}
	]},
	{"type":"quest","varients":[{"name":"legs","effect":"quest","consumable":false,"swap":{}}
	]}]
var paused:=false
var resetOnce:=false
var selectedItem:=-1
var exhausted=false
var pukestate=false
var effect=""
var warploc=2950
var hat=""
var mesmerized=false
var types=[{"name":"items/food/food","num":4},{"name":"items/scrap/scrap","num":4},{"name":"items/quest/legs","num":1}]

func reset():
	mesmerized=false
	hat=""
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
	playerStats={"health":playerStats.maxHealth,"maxHealth":playerStats.maxHealth,"stanima":playerStats.maxStanima,"maxStanima":playerStats.maxStanima,"stanimaRate":1,"speed":playerStats.maxSpeed,"maxSpeed":1,"power":playerStats.maxPower,"maxPower":1}
	playerSearch=false
	inSearch=false
	paused=false

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
