extends Area2D
var type="blood1"
var rng=RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tempt=rng.randi_range(1,6)
	if tempt==6:
		type="gem"
	else:
		type="blood"+str(tempt)	
	$AnimatedSprite2D.animation=type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if type=="gem":
		Flags.megaStats.gems+=1
	queue_free()	
