extends Node2D
var trashScene:PackedScene= load("res://trash.tscn") 
var ghostScene:PackedScene= load("res://ghost.tscn") 
var rng=RandomNumberGenerator.new()
var home=self
var offtimers=true


func _ready() -> void:
	$music.volume_db=Flags.options.music
#	devstart()



		

func start(called):
	offtimers=false
	Flags.mode="temple"
	home=called
	$music.play()
	for i in range(1,30):
		createtrash()
	Flags.tne.dotime(self,[starttrash],rng.randf_range(.2,2.5),"starttrash",true,"temple")

	Flags.tne.dotime(self,[startghost],rng.randf_range(1.5,3.5),"startghost",true,"temple")
	$templeplayer.start(called)

func devstart():
	start(self)
	
func reset():
	offtimers=true
	Flags.tne.killTimer("startghost","temple")
	Flags.tne.killTimer("starttrash","temple")
	Flags.clearnode($ghostholder)
	Flags.clearnode($trashlayer)
	
	
func createtrash():
		var tx=rng.randi_range(30,1500)
		var ty=rng.randi_range(30,500)
		var trash=trashScene.instantiate()
		trash.position.x=tx
		trash.position.y=ty
		$trashlayer.add_child(trash)	
		
		
func starttrash():
		createtrash()
		Flags.tne.dotime(self,[starttrash],rng.randf_range(.2,2.5),"starttrash",true,"temple")
		
func startghost():
	createghost()
	Flags.tne.dotime(self,[startghost],rng.randf_range(1.5,3.5),"startghost",true,"temple")
	
func createghost():
		var tx=rng.randi_range(-1000,1500)
		var ty=rng.randi_range(30,500)
		var ghost=ghostScene.instantiate()
		ghost.position.x=tx
		ghost.position.y=ty
		$ghostholder.add_child(ghost)	
		
func eliminateghosts(type):
	if $templeplayer.bag>9:
		for i in $ghostholder.get_children():
			i.dissapear(type)
	$templeplayer.bag=0

func exit(isdead=false):
	reset()
	$music.stop()
	print("exit")
	home.exit(isdead)


func _on_alter_body_entered(body: Node2D) -> void:

	$templeplayer.offer()
	eliminateghosts($alter.type)



func _on_exit_body_entered(body: Node2D) -> void:
	reset()
	$music.stop()
	home.exit()



func _on_music_finished() -> void:
	$music.play()
	pass # Replace with function body.
