extends CharacterBody2D


func start():
	velocity=Vector2(-1,-1)*20
		
func _physics_process(delta):
	if Flags.entered.active!=false:

		var coll=move_and_collide(velocity*20*delta)

		if (!coll):
			return
		velocity=velocity.bounce(coll.get_normal())

func paydirt():
	
	velocity.y=velocity.y*-1


func _on_comrock_area_entered(area: Area2D) -> void:
	area.staticly=false
