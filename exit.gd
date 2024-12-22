extends Area2D


func _on_body_entered(body: Node2D) -> void:

	if Flags.entered.active==true:
		if 	Flags.mode=="cryptominos":
			Flags.tne.addEvent("exit","cryptominos",true)


		Flags.paused=false;
		Flags.entered.active=false
