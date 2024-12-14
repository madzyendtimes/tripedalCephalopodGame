extends Area2D
var type=""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gettype()

	pass # Replace with function body.
func gettype():
	var rng=RandomNumberGenerator.new()
	var tempt=rng.randi_range(1,3)
	if tempt==1:
		type="holy"
	if tempt==2:
		type="demon"
	if tempt==3:
		type="peace"
	$AnimatedSprite2D.animation=type
	$AnimatedSprite2D.play()
	Flags.dotime(gettype,rng.randi_range(0.9,2.8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func inactive():
	$AnimatedSprite2D.animation=type

func _on_body_entered(body: Node2D) -> void:
	print("offering accepted")
	$AnimatedSprite2D.animation=type+"active"
	Flags.dotime(inactive,1.5)
	pass # Replace with function body.
