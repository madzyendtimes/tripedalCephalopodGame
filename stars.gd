extends Node2D

var type="star1"
var speed=4
var rot=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var num=Flags.rng.randi_range(1,10)
	type="star"+str(num)
	$AnimatedSprite2D.animation=type
	$AnimatedSprite2D.play()
	rot=Flags.rng.randf_range(-.1,.1)
		
	speed=Flags.rng.randi_range(2,6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y>800:
		queue_free()
		return
	position.y+=speed
	rotation+=rot
	scale.x+=Flags.rng.randf_range(-0.03,0.03)
	scale.y+=Flags.rng.randf_range(-0.03,0.03)
