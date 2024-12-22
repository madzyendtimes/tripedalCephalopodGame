extends Area2D

var type:="cryptominos"


var allreadyentered=false

func _ready() -> void:
	choosetype()

func choosetype():
	var choice=Flags.rng.randi_range(0,2)
	if choice==1:
		type="temple"
		$front.animation=type
		$back.animation=type
	if choice==2:
		type="witchhut"
		$front.animation=type
		$back.animation=type

func start(called):	
	called.get_node(type+"camera").make_current()
	Flags.mode=type
	called.get_node(type).start(called)


func close():
	$front.animation=type+"entered"
	
	
func _on_body_entered(body: Node2D) -> void:
	Flags.entered.ready=true
	Flags.entered.building=self
	Flags.entered.type=$front.animation
		
	
func _on_body_exited(body: Node2D) -> void:
	Flags.entered.ready=false
	
	
