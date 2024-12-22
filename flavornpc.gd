extends Node2D
var candeploy:=true


func choose():
	var num=Flags.flavornpc.npc.size()
	var choice=Flags.rng.randi_range(0,num-1)
	if Flags.flavornpc.npc[choice].deployed==false:
		Flags.flavornpc.npc[choice].deployed=true
		$npc.animation=Flags.flavornpc.npc[choice].name
		$text.animation=Flags.flavornpc.npc[choice].name+"text"
		$npc.play()
	else:
		candeploy=false
