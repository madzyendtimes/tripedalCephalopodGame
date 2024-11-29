extends RigidBody2D

velocity=Vector2(250,250)
var collision_info
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _physics_process(delta):
	collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		pass
func _on_body_entered(body: Node) -> void:
	velocity.reflect(collision_info.get_normal())
	
	pass # Replace with function body.
