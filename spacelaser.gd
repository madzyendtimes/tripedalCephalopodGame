extends StaticBody2D

var speed=10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func hit():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y-=speed
	if position.y<-200:
		queue_free()
