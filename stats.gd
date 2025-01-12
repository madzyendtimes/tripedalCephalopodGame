extends Control
var navDivide:=11
var eventq

func _ready():
	update()
	$PopupPanel2.visible=false
	$PopupPanel.visible=false


func showpop():
	pass
	

func _process(delta):
	if Flags.mode!="statsScreen":		
		return
	else:
		update()
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
				var pi=Flags.playerInventory[Flags.selectedItem-1]
				print(pi)
				Flags.tne.addEvent(pi.effect,"level")
				#Flags.effect=pi.effect
				var inInv=Flags.megaStats.inventory.find(pi)
				if inInv>-1:
					Flags.megaStats.inventory.remove_at(inInv)
				if pi.consumable==true:
					Flags.playerInventory.remove_at(Flags.selectedItem-1)
					if pi.swap!={}:
						doswap(pi.swap)
			contract()
		
		if Input.is_action_just_pressed("search"):
			if Flags.megaStats.transmute:
				if Flags.selectedItem<=Flags.playerInventory.size():
					var pi=Flags.playerInventory[Flags.selectedItem-1]					
					Flags.tne.addEvent("addgems","level")
					Flags.playerInventory.remove_at(Flags.selectedItem-1)
					var inInv=Flags.megaStats.inventory.find(pi)
					if inInv>-1:
						Flags.megaStats.inventory.remove_at(inInv)
					contract()
			
		if Input.is_action_just_pressed("run"):
			if Flags.megaStats.inventorycapacity>0:
				if Flags.selectedItem<=Flags.playerInventory.size():
					var pi=Flags.playerInventory[Flags.selectedItem-1]					
					Flags.megaStats.inventory.append(pi)
					if Flags.megaStats.inventory.size()>Flags.megaStats.inventorycapacity:
						Flags.megaStats.inventory.pop_front()
						
			print(Flags.megaStats.inventory)
			
		if Input.is_action_just_pressed("fight"):
			contract()
			
func doswap(obj):
	Flags.addToInventory(obj.type,obj.varient)
		


func SelectItem(selx,sely):
	var sz=Flags.playerInventory.size();
	if (sz>0):
		var oldSelect=Flags.selectedItem;
		if oldSelect>sz:
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
	$PopupPanel/statbar/Label.text="health :"+str(Flags.playerStats.health)+" - stanima :"+str(Flags.playerStats.stanima)+" - speed : "+str(Flags.playerStats.speed)+ " - power : "+str(Flags.playerStats.power)+" - gems: "+str(Flags.megaStats.gems)
	#$PopupPanel/TextureProgressBar.max_value=Flags.playerStats.maxHealth
	#$PopupPanel/TextureProgressBar.value=Flags.playerStats.health
	#"loc:"+str(Flags.l)
	
func contract():
	print("contract")
	$PopupPanel.visible=false
	$PopupPanel2.visible=false
	Flags.paused=false
	Flags.mode="level"
	
func expand():
	print("expand")
	$PopupPanel.visible=true
#	$PopupPanel.size.y=100
	Flags.mode="statsScreen"
	$PopupPanel2.visible=true
	Flags.paused=true

func clear():
	$PopupPanel2/VBoxContainer/inv.clear()
	$PopupPanel2/VBoxContainer/inv.add_text("select an item and press 'a' to use\n\n\n")

func addInventory(item,itemnum):
	var t=Texture.new()
	t=load(item.img)
	#change to buttons with icons?
	$PopupPanel2/VBoxContainer/inv.add_image(t,100,100,Color(1,1,1,1),5,Rect2(0,0,0,0),"k"+str(itemnum))
	
