extends Control
var navDivide:=11


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	$PopupPanel2.visible=false



func showpop():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(Flags.paused)
	if Flags.paused==false:		
		update()
	else:
		if Input.is_action_just_pressed("right"):
			SelectItem(1,0)
		if Input.is_action_just_pressed("left"):
			SelectItem(-1,0)
		if Input.is_action_just_pressed("up"):
			SelectItem(0,-1)
		if Input.is_action_just_pressed("down"):
			SelectItem(0,1)
		if Input.is_action_just_pressed("jump"):
			pass
		if Input.is_action_just_pressed("reset")&&Flags.resetOnce==true:
			
			contract()
		


func SelectItem(selx,sely):
	Flags.selectedItem+=max(min(selx,0),$PopupPanel2/VBoxContainer/inv.get_child_count())
	Flags.selectedItem+=max(min(sely,0)*11,$PopupPanel2/VBoxContainer/inv.get_child_count())
	print(Flags.selectedItem)
	pass
	

func update():
	$PopupPanel.visible=true
	$PopupPanel/statbar/Label.text="health :"+str(Flags.playerStats.health)+" - stanima :"+str(Flags.playerStats.stanima)+" - speed :"+str(Flags.playerStats.speed)+ " - power : "+str(Flags.playerStats.power)
	
func contract():
	update()
	$PopupPanel2.visible=false
	Flags.paused=false
	
func expand():
#	$PopupPanel.size.y=100
	$PopupPanel2.visible=true
	Flags.paused=true

func clear():
	$PopupPanel2/VBoxContainer/inv.clear()

func addInventory(item):
	var t=Texture.new()
	t=load(item.img)
	$PopupPanel2/VBoxContainer/inv.add_image(t,100,100)
	
