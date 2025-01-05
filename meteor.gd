extends Area2D
var speed=5
var xspeed=0
var rot=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed=Flags.rng.randi_range(2,7)
	xspeed=Flags.rng.randi_range(-2,2)
	position.x=Flags.rng.randi_range(-400,1200)
	rot=Flags.rng.randf_range(-0.1,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y+=speed
	position.x+=xspeed
	rotation+=rot
	if position.y>1200:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body.name.find("laser")>-1:
		get_parent().addgems()
		queue_free()
		return

	body.hit()
	queue_free()
