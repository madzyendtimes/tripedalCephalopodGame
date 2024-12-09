extends Area2D
var type="peace"
var rng=RandomNumberGenerator.new()
var speed=1
var tx=0
var ty=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tempt=rng.randi_range(1,3)
	if tempt==1:
		type="holy"
	if tempt==2:
		type="demon"
	if tempt==3:
		type="peace"
	$AnimatedSprite2D.animation=type		
	$AnimatedSprite2D.play()
	getdir()


func getdir():
	tx=rng.randi_range(-1,1)

	ty=rng.randi_range(-1,1)
	Flags.dotime(getdir,rng.randf_range(.2,1.5))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y+=ty*speed
	position.x+=tx*speed
	pass

func kill():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	body.hit()
	
