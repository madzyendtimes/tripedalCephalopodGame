extends Node

var canJump:=true
var inFight:=false
var playerDead:=false
var playerInventory:=[]
var playerStats:={"health":1,"maxHealth":1,"stanima":600,"maxStanima":600,"stanimaRate":1,"speed":1,"maxSpeed":1,"power":1,"maxPower":1}
var baseStats=playerStats
var playerSearch:=false
var inSearch:=false
var dir:=1
var itemMap:=[{"type":"food","varients":[{"name":"old pizza"},{"name":"noodles... or worms!"},{"name":"suspect sandwitch"}]},{"type":"scrap","varients":[{"name":"tin foil hat"},{"name":"crushed soda"},{"name":"broken mirror"}]},[{"type":"quest","varients":[{"name":"legs"}]}]]
var paused:=false
var resetOnce:=false
var selectedItem:=-1
var exhausted=false
var pukestate=false



func reset():
	pukestate=false
	exhausted=false
	selectedItem=-1
	dir=1
	canJump=true
	inFight=false
	playerDead=false
	playerInventory=[]
	playerStats={"health":playerStats.maxHealth,"maxHealth":1,"stanima":playerStats.maxStanima,"maxStanima":600,"stanimaRate":1,"speed":playerStats.maxSpeed,"maxSpeed":1,"power":playerStats.maxPower,"maxPower":1}
	playerSearch=false
	inSearch=false
	paused=false
