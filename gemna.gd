extends Area2D
var caninteract=false
var mode="trader"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	caninteract=true
	Flags.interactablenpc=self
	print("gemna")
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	
	caninteract=false
	Flags.interactablenpc=null
	pass # Replace with function body.

func complete():
	caninteract=false
	Flags.interactablenpc=null
	Flags.mode="level"
	$AnimatedSprite2D.animation="gemnacomplete"
	$text.animation="textcomplete"