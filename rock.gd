extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Flags.weather=="rain":
		position.x+=.5
	
	pass

func setAnimation(val):
	$AnimatedSprite2D.animation="rock"+val
	
	


func _on_body_entered(body):
	
	$"../../player".hit()
	
func hit():
	$AnimatedSprite2D.animation="explode"
	await get_tree().create_timer(1.0).timeout
	queue_free()
