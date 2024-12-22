extends Area2D

func _ready() -> void:
	if Flags.controlScheme=="keyboard":
		$text.animation="keyboardtext"



func _on_body_entered(body: Node2D) -> void:
	var count=0
	for x in Flags.playerInventory:
		if (x.type==3)&&(x.item==2):
			$AnimatedSprite2D.animation="questcomplete"
			#todo - incorporate into quest dictionary
			$text.animation="complete"
			
			Flags.playerInventory.remove_at(count)
		count+=1	
	
