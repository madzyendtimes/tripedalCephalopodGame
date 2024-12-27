extends Area2D

var caninteract=false
var npc={}
var noninteractable=false
var mode="level"
var candeploy=true

#		{"name":"epsilon frank","deployed":false,"code":"e","scene":"jobboard"},
		#{"name":"gemna","deployed":false,"code":"g","scene":"trader"}
func choose():
	var rnd=Flags.rng.randi_range(0,Flags.specialnpc.size()-1)
	npc=Flags.specialnpc[rnd]
	if npc.deployed:
		for i in Flags.specialnpc:
			if npc.deployed:
				candeploy=false
				continue
			npc=i
		if npc.deployed:
			$npc.animation="nothing"
			$text.animation="nothing"		
			caninteract=false	
			noninteractable=true
			candeploy=false
			return
			
	Flags.specialnpc[rnd].deployed=true
	mode=npc.scene
	$npc.animation=npc.code		
	position.y+=npc.ypos
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
