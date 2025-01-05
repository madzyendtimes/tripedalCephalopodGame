extends Area2D
var speed=10
var rot=0
var active=false

func start(prot):
	rot=prot
	active=true
	rotation=prot


func _process(delta: float) -> void:
	if !active && !Flags.special=="ufo":
		return
	if position.y>550:
		queue_free()
	position.y+=speed
	position.x+=rot*(speed/2)


func hit():
	pass
	
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("getufo"):
		if body.ufo:
			return
		print("laser hit")
		body.hit()
		queue_free()
