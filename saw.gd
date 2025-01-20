extends "res://basemonster.gd"

func _ready():
	enemytype=Flags.enemytypes.saw.duplicate()

func hit(dmg=1):
	pass

func _on_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		body.hit()
		
		return
	if !dead:
		body.hit(enemytype)
