extends CanvasLayer





func punish():
	visible=true
	$AnimatedSprite2D.play()
	Flags.tne.dotime(self,[calm],1.0,"calm"+str(self.get_instance_id()),true,"temple")

func calm():
	visible=false
	
		
