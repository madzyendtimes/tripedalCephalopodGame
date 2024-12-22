extends Area2D


func _ready():
	$AnimatedSprite2D.play()


func _process(delta):
	if Flags.weather=="rain":
		position.x+=.5
	


func setAnimation(val):
	$AnimatedSprite2D.animation="rock"+str(val)
	
	
func choose():
	setAnimation(Flags.rng.randi_range(1,3))

func _on_body_entered(body):
	
	body.hit()
	
func hit():
	$AnimatedSprite2D.animation="explode"
	await get_tree().create_timer(1.0).timeout
	queue_free()
