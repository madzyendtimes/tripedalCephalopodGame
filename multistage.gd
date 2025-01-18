extends "res://basemonster.gd"

func _ready():
	enemytype=Flags.enemytypes["goop baby"].duplicate()
		
	
func hit(dmg=1):

	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	enemytype.hp=Flags.calchits(enemytype.hp)

	Flags.play("multihit")
	if enemytype.hp<1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		return

	
	if enemytype.hp<2:
		$AnimatedSprite2D.animation="short"
		enemytype.pow=1
		enemytype.speed=1.2
		$collisiontall.position.y=200
		
