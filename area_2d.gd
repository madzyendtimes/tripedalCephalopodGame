extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doaniChange()
	var rng=RandomNumberGenerator.new()
	$AnimatedSprite2D.flip_h=!rng.randi_range(0,1)>0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func doaniChange():
	
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


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	$"../../player".hit()
	pass # Replace with function body.
