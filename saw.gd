extends Area2D
var dead=false
var enemytype={"name":"saw","flying":false,"hp":1,"begchance":0,"speed":0,"pow":1}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		body.hit(enemytype.pow)
