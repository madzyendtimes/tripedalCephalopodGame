extends Area2D
var type=""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gettype()

func gettype():
	var tempt=Flags.rng.randi_range(1,3)
	if tempt==1:
		type="holy"
	if tempt==2:
		type="demon"
	if tempt==3:
		type="peace"
	$AnimatedSprite2D.animation=type
	$AnimatedSprite2D.play()

	Flags.tne.dotime(self,[gettype],Flags.rng.randf_range(0.9,2.8),"gettype",true,"temple")

func inactive():
	$AnimatedSprite2D.animation=type

func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.animation=type+"active"
	Flags.save()
	Flags.tne.dotime(self,[inactive],1.5,"inactive",true,"temple")
