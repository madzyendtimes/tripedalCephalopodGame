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
	
	print(body)
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		hit()
	
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	
	
	
	body.hit()
	
func hit():
	$AnimatedSprite2D.animation="explode"
	await get_tree().create_timer(1.0).timeout
	queue_free()
