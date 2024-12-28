extends Node2D
var candeploy:=true
var questable=false
var quest={}
var who=""

func choose():
	if Flags.flavornpc.npc.size()<1:
		candeploy=false
		return
	Flags.flavornpc.npc.shuffle()
	var npc=Flags.flavornpc.npc.pop_back()
	if npc==null:
		candeploy=false
		return
	who=npc.name
	$npc.animation=npc.name
	$text.animation=npc.name+"text"
	$npc.play()
	if npc.quest !={}:
		questable=true
		quest=npc.quest
			
	if npc.scale>0:
		$npc.scale.y=npc.scale
	$npc.position.y+=npc.ypos
	$text.position.y+=npc.ypos
	


func _on_body_entered(body: Node2D) -> void:
	if questable==true:
		var success=true
		for i in quest.requirements:
			success=success&&checkrequirements(i.type,i.num)
		if success:
			$npc.animation=who+"complete"
			$text.animation=who+"completetext"
			questable=false
			Flags.tne.addEvent(quest.reward,"level",true)
		
		
			#{"name":"emmaemo","deployed":false,"quest":[{"requirements":[{"type":3,"num":3}],"reward":"gun"}]},
func checkrequirements(type,num):
	for i in Flags.playerInventory:
		if i.type==type && i.item==num:
			return true
	return false	
	
	
