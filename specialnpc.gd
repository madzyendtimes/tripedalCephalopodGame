extends Area2D

var caninteract=false
var npc={}
var noninteractable=false
var mode="level"
var candeploy=true

#		{"name":"epsilon frank","deployed":false,"code":"e","scene":"jobboard"},
		#{"name":"gemna","deployed":false,"code":"g","scene":"trader"}
func choose():
	if Flags.specialnpc.size()<1:
		candeploy=false
		return
	Flags.specialnpc.shuffle()	
	npc=Flags.specialnpc.pop_back()
	mode=npc.scene
	$npc.animation=npc.code		
	$npc.position.y+=npc.ypos
	$npc.play()	
	var kb=""
	if Flags.controlScheme=="keyboard":
		kb="keyboard"
	$text.animation=npc.code+kb

func _on_body_entered(body: Node2D) -> void:
	if noninteractable:
		return
	caninteract=true
	Flags.interactablenpc=self

func _on_body_exited(body: Node2D) -> void:
	if noninteractable:
		return	
	caninteract=false
	Flags.interactablenpc=null


func complete():
	caninteract=false
	Flags.interactablenpc=null
	Flags.mode="level"
	$npc.animation=npc.code+"pq"
	$text.animation=npc.code+"pq"
