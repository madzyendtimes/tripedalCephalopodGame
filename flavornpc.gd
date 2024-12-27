extends Node2D
var candeploy:=true
var questable=false
var quest={}
var who=""

func choose():
	var num=Flags.flavornpc.npc.size()
	var choice=Flags.rng.randi_range(0,num-1)
	if Flags.flavornpc.npc[choice].deployed==false:
		Flags.flavornpc.npc[choice].deployed=true
		who=Flags.flavornpc.npc[choice].name
		$npc.animation=Flags.flavornpc.npc[choice].name
		$text.animation=Flags.flavornpc.npc[choice].name+"text"
		$npc.play()
		if Flags.flavornpc.npc[choice].quest !={}:
			questable=true
			quest=Flags.flavornpc.npc[choice].quest
			
		if Flags.flavornpc.npc[choice].scale>0:
			scale.x=Flags.flavornpc.npc[choice].scale
			scale.y=scale.x
	else:
		candeploy=false
	


func _on_body_entered(body: Node2D) -> void:
	if questable==true:
		var success=true
		for i in quest.requirements:
			success=success&&checkrequirements(i.type,i.num)
		if success:
			$npc.animation=who+"complete"
			$text.animation=who+"completedtext"
			questable=false
			Flags.tne.addEvent(quest.reward,"level",true)
		
		
			#{"name":"emmaemo","deployed":false,"quest":[{"requirements":[{"type":3,"num":3}],"reward":"gun"}]},
func checkrequirements(type,num):
	for i in Flags.playerInventory:
		if i.type==type && i.item==num:
			return true
	return false	
	
	
