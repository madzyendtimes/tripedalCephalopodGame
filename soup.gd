extends Node2D

var wait=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func ouch():
	$AnimatedSprite2D.animation="ouch"
	Flags.dotime(calm,0.5)

func complete():
	wait=true
	$AnimatedSprite2D.animation="gem"
	Flags.dotime(completecalm,1.0)


func completecalm():
	Flags.witchevents="gemmonster"
	wait=false
	calm()


func calm():
	if !wait:
		$AnimatedSprite2D.animation="calm"

func splash():
	if !wait:
		$AnimatedSprite2D.animation="splash"
		Flags.dotime(calm,0.5)
