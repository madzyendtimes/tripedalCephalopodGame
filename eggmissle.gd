extends Area2D
var flat=false
var speed=3
var flatland=450

func _ready() -> void:
	flatland+=Flags.rng.randi_range(-10,40)


func _process(delta: float) -> void:
	if flat:
		return
	position.y+=1*speed
	if position.y>flatland:
		flat=true

		$AnimatedSprite2D.animation="aftermath"

func hit(dmg=1):
	pass

func _on_body_entered(body: Node2D) -> void:
	if !flat:

		body.hit(1)
		queue_free()
