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
	
			if Flags.selectedItem<=Flags.playerInventory.size():
				Flags.effect=Flags.playerInventory[Flags.selectedItem-1].effect
				if Flags.playerInventory[Flags.selectedItem-1].consumable==true:
					Flags.playerInventory.remove_at(Flags.selectedItem-1)
					
			else:
				Flags.effect=""
			contract()
		
			
		if Input.is_action_just_pressed("reset")&&Flags.resetOnce==true:
			
			contract()
		


func SelectItem(selx,sely):
	var sz=Flags.playerInventory.size();
	if (sz>0):
		var oldSelect=Flags.selectedItem;
		if oldSelect>=sz:
			oldSelect=0
		Flags.selectedItem+=min(selx,sz)
		Flags.selectedItem+=min(sely*11,sz)
		if oldSelect>0:
			$PopupPanel2/VBoxContainer/inv.update_image("k"+str(oldSelect),RichTextLabel.UPDATE_SIZE,Flags.playerInventory[oldSelect-1].imgt,100,100,Color(1.0,1.0,1.0,1.0))
			$PopupPanel2/VBoxContainer/inv.update_image("k"+str(oldSelect),RichTextLabel.UPDATE_COLOR,Flags.playerInventory[oldSelect-1].imgt,100,100,Color(1.0,1.0,1.0,1.0))
		if Flags.selectedItem<1:
			Flags.selectedItem=1
		if  Flags.selectedItem>sz:
			Flags.selectedItem=sz
		var texture=Flags.playerInventory[Flags.selectedItem-1].imgt

		$PopupPanel2/VBoxContainer/inv.update_image("k"+str(Flags.selectedItem),RichTextLabel.UPDATE_SIZE,texture,150,150,Color(1.0,1.0,0.0,1.0))
		$PopupPanel2/VBoxContainer/inv.update_image("k"+str(Flags.selectedItem),RichTextLabel.UPDATE_COLOR,texture,150,150,Color(1.0,0.0,0.0,1.0))
#		

	

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
	$PopupPanel2/VBoxContainer/inv.add_text("select an item and press 'a' to use\n\n\n")

func addInventory(item,itemnum):
	var t=Texture.new()
	t=load(item.img)
	$PopupPanel2/VBoxContainer/inv.add_image(t,100,100,Color(1,1,1,1),5,Rect2(0,0,0,0),"k"+str(itemnum))
	
