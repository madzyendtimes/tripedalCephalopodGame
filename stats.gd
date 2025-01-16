extends Control
var navDivide:=11
var eventq
var invScene:PackedScene=load("res://invImg.tscn")
var ainv=[]
var useitem
var transitem
var bequeathitem
var submenus=false
var subfocus=false
var function=-1
var afuncs=[]

func _ready():
	update()
	$VBoxContainer/PopupPanel2.visible=false
	$PopupPanel.visible=false
	if Flags.megaStats.transmute || Flags.megaStats.inventorycapacity>0:
		submenus=true
		$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.add_item("USE")
		afuncs.append("use")
		if Flags.megaStats.transmute:
			$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.add_item("TRANSMUTE")
			afuncs.append("transmute")
		if Flags.megaStats.inventorycapacity>0:
			$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.add_item("BEQUEATH")
			afuncs.append("bequeath")
		
		$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.visible=false

func showpop():
	pass
	

func _process(delta):
	if Flags.mode!="statsScreen":		
		return
	else:
		update()
		if !subfocus:
			if Input.is_action_just_pressed("right"):
				SelectItem(1,0)
			if Input.is_action_just_pressed("left"):
				SelectItem(-1,0)
			if Input.is_action_just_pressed("up"):
				SelectItem(0,-1)
			if Input.is_action_just_pressed("down"):
				SelectItem(0,1)
		if Input.is_action_just_pressed("jump"):
			if !submenus:
				douse()
			else:
				if subfocus:
					match afuncs[function]:
						"use":
							douse()
							return
						"transmute":
							dotransmute()
							return
						"bequeath":
							dobequeath()
							return
						_:
							contract()
							return			
				$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.visible=true
				$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.grab_focus()
				subfocus=true
				
		if Input.is_action_just_pressed("search"):
			dotransmute()
			
		if Input.is_action_just_pressed("run"):
			dobequeath()

			
		if Input.is_action_just_pressed("fight"):
			contract()

func dobequeath():
	if Flags.megaStats.inventorycapacity>0:
		if Flags.selectedItem<=Flags.playerInventory.size():
			var pi=Flags.playerInventory[Flags.selectedItem-1]
			if pi.has("bequeathed"):
				if !pi.bequeathed:
					Flags.playerInventory[Flags.selectedItem-1].bequeathed=true
					Flags.megaStats.inventory.append(pi)
					if Flags.megaStats.inventory.size()>Flags.megaStats.inventorycapacity:
						Flags.megaStats.inventory.pop_front()
			else:
				Flags.playerInventory[Flags.selectedItem-1]["bequeathed"]=false
			
			rewill()
			unmenu()

func unmenu():
	$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.visible=false
	subfocus=false
	

func dotransmute():
	if Flags.megaStats.transmute:
		if Flags.selectedItem<=Flags.playerInventory.size():
			var pi=Flags.playerInventory[Flags.selectedItem-1]					
			Flags.tne.addEvent("addgems","level")
			Flags.playerInventory.remove_at(Flags.selectedItem-1)
			var inInv=Flags.megaStats.inventory.find(pi)
			if inInv>-1:
				Flags.megaStats.inventory.remove_at(inInv)
			contract()


func douse():
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
			$VBoxContainer/PopupPanel2/VBoxContainer/inv.update_image("k"+str(oldSelect),RichTextLabel.UPDATE_SIZE,ainv[oldSelect-1],100,100,Color(1.0,1.0,1.0,1.0))
			$VBoxContainer/PopupPanel2/VBoxContainer/inv.update_image("k"+str(oldSelect),RichTextLabel.UPDATE_COLOR,ainv[oldSelect-1],100,100,Color(1.0,1.0,1.0,1.0))
		if Flags.selectedItem<1:
			Flags.selectedItem=1
		if  Flags.selectedItem>sz:
			Flags.selectedItem=sz
		var texture=ainv[Flags.selectedItem-1]
		#Flags.playerInventory[Flags.selectedItem-1].imgt
		print(Flags.playerInventory)
		print(Flags.selectedItem)
		$VBoxContainer/PopupPanel2/VBoxContainer/inv.update_image("k"+str(Flags.selectedItem),RichTextLabel.UPDATE_SIZE,texture,150,150,Color(1.0,1.0,0.0,1.0))
		$VBoxContainer/PopupPanel2/VBoxContainer/inv.update_image("k"+str(Flags.selectedItem),RichTextLabel.UPDATE_COLOR,texture,150,150,Color(1.0,1.0,0.0,1.0))
		$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.position.x=((Flags.selectedItem%11)*100)-50
		$VBoxContainer/PopupPanel2/VBoxContainer/inv/PopupMenu.position.y=(floor(Flags.selectedItem/11)*100)+100

	

func update():
	$PopupPanel/statbar/Label.text="health :"+str(Flags.playerStats.health)+" - stanima :"+str(Flags.playerStats.stanima)+" - speed : "+str(Flags.playerStats.speed)+ " - power : "+str(Flags.playerStats.power)+" - gems: "+str(Flags.megaStats.gems)

	
func contract():
	print("contract")
	$PopupPanel.visible=false
	$VBoxContainer/PopupPanel2.visible=false
	Flags.paused=false
	Flags.mode="level"
	unmenu()

func expand():
	print("expand")
	$PopupPanel.visible=true
#	$PopupPanel.size.y=100
	Flags.mode="statsScreen"
	$VBoxContainer/PopupPanel2.visible=true
	Flags.paused=true
	subfocus=false

func clear():
	ainv=[]
	$VBoxContainer/PopupPanel2/VBoxContainer/inv.clear()
	$VBoxContainer/PopupPanel2/VBoxContainer/inv.add_text("select an item and press 'a' to use\n\n\n")
	rewill()

func rewill():
	var t=Texture.new()
	t=load("res://items/will.PNG")
	$VBoxContainer/PopupPanel2/VBoxContainer/hbinv/CanvasLayer/HBoxContainer2/RichTextLabel.clear()
	$VBoxContainer/PopupPanel2/VBoxContainer/hbinv/CanvasLayer/HBoxContainer2/RichTextLabel.add_image(t,100,100,"white",5,Rect2(0,0,0,0))
	print(Flags.megaStats.inventory)
	for i in Flags.megaStats.inventory:
		addtowill(i.img)


func addtowill(img):
	var t=Texture.new()
	t=load(img)

	$VBoxContainer/PopupPanel2/VBoxContainer/hbinv/CanvasLayer/HBoxContainer2/RichTextLabel.add_image(t,100,100,"white",5,Rect2(0,0,0,0))
	
func addInventory(item,itemnum):
	var t=Texture.new()
	t=load(item.img)
	$VBoxContainer/PopupPanel2/VBoxContainer/inv.add_image(t,100,100,"white",5,Rect2(0,0,0,0),"k"+str(itemnum))
	ainv.append(t)




func _on_popup_menu_id_focused(id: int) -> void:
	function=id
	print("FUNCTION!!!!----",id)
