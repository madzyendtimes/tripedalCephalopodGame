extends CharacterBody2D
var type=""
var dodrop=false
var speed=10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dodrop:
		position.y+=1*speed


func settype(ptype):
	$AnimatedSprite2D.animation=ptype
	type=ptype

func drop():
	dodrop=true
