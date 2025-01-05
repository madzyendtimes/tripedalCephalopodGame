extends Area2D

var dir=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Flags.tne.dotime(self,[dissipate] ,Flags.rng.randf_range(.5,2.5),"killgas"+str(get_instance_id()),true,"level")
	$AnimatedSprite2D.play()
	if Flags.rng.randi_range(0,1)==1:
		$AnimatedSprite2D.flip_h=true

func dissipate():
	queue_free()

func hit():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x+=Flags.rng.randi_range(0,5)*dir
	if Flags.rng.randi_range(0,100)>85:
		dir*=-1


func _on_body_entered(body: Node2D) -> void:
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		return

	Flags.tne.addEvent("shrinkgas","level")
