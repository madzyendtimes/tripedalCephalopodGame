extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
#	
	pass # Replace with function body.

func start():
	velocity=Vector2(-1,-1)*20
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta):
	if Flags.entered.active!=false:

		var coll=move_and_collide(velocity*20*delta)

		if (!coll):
			return
		velocity=velocity.bounce(coll.get_normal())

func paydirt():
	
	velocity.y=velocity.y*-1

func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_comrock_area_entered(area: Area2D) -> void:
	area.staticly=false
	pass # Replace with function body.


func _on_floor_body_entered(body: Node2D) -> void:
	pass
	#print(body.name)
	#if body.name.find("pickaxe")>-1:
	#	queue_free()
	#pass # Replace with function body.
