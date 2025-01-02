extends Area2D
var dead=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit():
	pass


func _on_body_entered(body: Node2D) -> void:
	if dead:
		return
	if body.name.find("bullet")>-1:
		$AnimatedSprite2D.animation="dead"
		dead=true	
		body.hit()
		return
	if !dead:
		body.hit()
