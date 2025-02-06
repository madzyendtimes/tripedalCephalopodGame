extends AnimatedSprite2D

func _ready() -> void:
	var gtmp=Flags.rng.randi_range(1,26)
	animation="g"+str(gtmp)
	play()
	position.y=Flags.rng.randi_range(-25,25)
