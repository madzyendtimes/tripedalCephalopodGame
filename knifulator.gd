extends Node2D
var dead=false
var hp=1
var enemytype=Flags.enemytypes.knifeulator.duplicate()

func _process(delta: float) -> void:
	if dead:
		return
	match $attack/AnimatedSprite2D.frame:
		0:
			$attack/CollisionShape2D.position.y=-50
			$attack/CollisionShape2D.position.x=200
		1:
			$attack/CollisionShape2D.position.y=0
			$attack/CollisionShape2D.position.x=180
		2:
			$attack/CollisionShape2D.position.y=80
			$attack/CollisionShape2D.position.x=50
		3:
			$attack/CollisionShape2D.position.y=90
			$attack/CollisionShape2D.position.x=0
		4:
			$attack/CollisionShape2D.position.y=85
			$attack/CollisionShape2D.position.x=-75
		5:
			$attack/CollisionShape2D.position.y=75
			$attack/CollisionShape2D.position.x=-125
		6:
			$attack/CollisionShape2D.position.y=0
			$attack/CollisionShape2D.position.x=-150
		7:
			$attack/CollisionShape2D.position.y=-60
			$attack/CollisionShape2D.position.x=-150
		8:
			$attack/CollisionShape2D.position.y=-140
			$attack/CollisionShape2D.position.x=-50
		9:
			$attack/CollisionShape2D.position.y=-140
			$attack/CollisionShape2D.position.x=70					



func _on_attack_body_entered(body: Node2D) -> void:
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		hit()
		body.hit()
		return
	if !dead:
		body.hit(enemytype.pow)


func hit(dmg=1):
	enemytype.hp=Flags.calchits(enemytype.hp)
	if enemytype.hp<1:
		$attack/AnimatedSprite2D.animation="dead"
		dead=true	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		return



func _on_hurt_body_entered(body: Node2D) -> void:
	if Flags.inFight:
		hit()
