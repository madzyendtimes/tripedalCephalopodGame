extends CharacterBody2D
var type=""
var dodrop=false
var speed=10

func _process(delta: float) -> void:
	if dodrop:
		position.y+=1*speed
		
func settype(ptype):
	$AnimatedSprite2D.animation=ptype
	type=ptype

func drop():
	dodrop=true
