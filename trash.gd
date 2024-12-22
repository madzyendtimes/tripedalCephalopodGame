extends Area2D
var type="blood1"

func _ready() -> void:
	var tempt=Flags.rng.randi_range(1,6)
	if tempt==6:
		type="gem"
	else:
		type="blood"+str(tempt)	
	$AnimatedSprite2D.animation=type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.inoffer:
		return
	if body.bag>9:
		return

	if type=="gem":
		Flags.megaStats.gems+=1
	body.clean()
	queue_free()	
