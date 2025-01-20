extends Area2D
var speed=10
var rot=0
var active=false
var	enemytype=Flags.enemytypes.laser.duplicate()
func start(prot):
	rot=prot
	active=true
	rotation=prot


func _process(delta: float) -> void:
	if !active && !Flags.special=="ufo":
		return
	if position.y>550:
		queue_free()
	position.y+=max(speed*rot,3)
	position.x+=rot*(speed/2)


func hit(dmg=1):
	pass
	
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("getufo"):
		if body.ufo:
			return
		body.hit(enemytype)
		queue_free()
