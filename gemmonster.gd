extends Area2D

var dir=-1
var runningaway=false
var speed=3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.x<-200 && Flags.mode=="witchhut":
			Flags.witchevents="gemcaught"
			queue_free()
			return

	position.x+=dir*speed
	pass



func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1
		Flags.dotime(recourage,3.0)
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false



func _on_body_entered(body: Node2D) -> void:
	if Flags.mode=="level":
			if Flags.inFight==true:
				Flags.effect="addgems"
				queue_free()
			else:
				Flags.effect="hit"

		
