extends Node2D
var trashScene:PackedScene= load("res://trash.tscn") 
var ghostScene:PackedScene= load("res://ghost.tscn") 

var home=self
var offtimers=true


func _ready() -> void:
	#$music.volume_db=Flags.options.music
#	devstart()
	pass


		

func start(called):
	offtimers=false
	Flags.mode="temple"
	home=called
	#$music.play()
	Flags.play("templemusic","music")
	for i in range(1,30):
		createtrash()
	Flags.tne.dotime(self,[starttrash],Flags.rng.randf_range(.2,2.5),"starttrash",true,"temple")

	Flags.tne.dotime(self,[startghost],Flags.rng.randf_range(1.5,3.5),"startghost",true,"temple")
	$templeplayer.start(called)
	Flags.recordAcheivement("enteredtemple")

func paused():
	return Flags.mode!="temple"


func devstart():
	start(self)
	
func reset():
	#check for infinite regression?
	offtimers=true
	Flags.tne.killTimer("startghost","temple")
	Flags.tne.killTimer("starttrash","temple")
	Flags.clearnode($ghostholder)
	Flags.clearnode($trashlayer)
	
	
func createtrash():
		var tx=Flags.rng.randi_range(30,1500)
		var ty=Flags.rng.randi_range(30,500)
		var trash=trashScene.instantiate()
		trash.position.x=tx
		trash.position.y=ty
		$trashlayer.add_child(trash)	
		
		
func starttrash():
	if !paused():
		createtrash()
	Flags.tne.dotime(self,[starttrash],Flags.rng.randf_range(.2,2.5),"starttrash",true,"temple")
		
func startghost():
	if !paused():	
		createghost()
	Flags.tne.dotime(self,[startghost],Flags.rng.randf_range(1.5,3.5),"startghost",true,"temple")
	
func createghost():
		var tx=Flags.rng.randi_range(-1000,1500)
		var ty=Flags.rng.randi_range(30,500)
		var ghost=ghostScene.instantiate()
		ghost.position.x=tx
		ghost.position.y=ty
		$ghostholder.add_child(ghost)	
		
func eliminateghosts(type):
	if $templeplayer.bag>9:
		$templeplayer.stat("offering accepted","offer"+type,0)
		for i in $ghostholder.get_children():
			i.dissapear(type)
	$templeplayer.bag=0

func exit(isdead=false):
	reset()
#	$music.stop()
#	print("exit")
	home.exit(isdead)


func _on_alter_body_entered(body: Node2D) -> void:

	$templeplayer.offer()
	eliminateghosts($alter.type)



func _on_exit_body_entered(body: Node2D) -> void:
	reset()
#	$music.stop()
	home.exit()



func _on_music_finished() -> void:
	#$music.play()
	pass
