extends Area2D
var flat=false
var speed=3

func _ready() -> void:
	pass





func _process(delta: float) -> void:
	if flat:
		return
	position.y+=1*speed
	if position.y>450:
		flat=true

		$AnimatedSprite2D.animation="aftermath"



func _on_body_entered(body: Node2D) -> void:
	if !flat:

		body.hit()
		queue_free()
