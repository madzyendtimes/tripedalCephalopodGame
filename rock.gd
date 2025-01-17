extends Area2D
var enemytype={"name":"rock","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1}

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
		return
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	
	
	
	body.hit(enemytype.pow)
	
func hit(dmg=1):
	Flags.play("splode")
	$AnimatedSprite2D.animation="explode"
	Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
	await get_tree().create_timer(1.0).timeout
	queue_free()
