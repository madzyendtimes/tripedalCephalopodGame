extends Area2D
var caninteract=false
var mode="trader"


func _ready() -> void:
	if Flags.controlScheme=="keyboard":
		$text.animation="keyboardtext"

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
