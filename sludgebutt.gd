extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	var count=0
	for x in Flags.playerInventory:
		if (x.type==2)&&(x.item==2):
			$AnimatedSprite2D.flip_h=true
			$text.animation="complete"

			Flags.playerInventory.remove_at(count)
		count+=1	
	
	pass # Replace with function body.