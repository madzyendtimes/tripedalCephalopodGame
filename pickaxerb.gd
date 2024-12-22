extends RigidBody2D

velocity=Vector2(250,250)
var collision_info




func _physics_process(delta):
	collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		pass
func _on_body_entered(body: Node) -> void:
	velocity.reflect(collision_info.get_normal())
