extends Area2D

var dead=false
var enemytype={"name":"expander","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1}

func _ready() -> void:
	doaniChange()
	$AnimatedSprite2D.flip_h=!Flags.rng.randi_range(0,1)>0


func doaniChange():
	if dead:
		return
	if $AnimatedSprite2D.animation=="default":
		$AnimatedSprite2D.animation="descend"
		$CollisionShape2D.position.y=377
	else:
		$CollisionShape2D.position.y=96
		$AnimatedSprite2D.animation="default"
	if get_tree()!=null:
		await get_tree().create_timer(2).timeout
		if doaniChange != null:
			doaniChange()


func hit(dmg=1):
	pass


func _on_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.name.find("bullet")>-1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		body.hit()
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})		
		return
	if !dead:
		body.hit(enemytype.pow)
