extends Area2D

var type:="cryptominos"


var allreadyentered=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	choosetype()
	pass # Replace with function body.

func choosetype():
	var rng:=RandomNumberGenerator.new()
	var choice:=rng.randi_range(0,2)
	if choice==1:
		type="temple"
		$front.animation=type
		$back.animation=type
	if choice==2:
		type="witchhut"
		$front.animation=type
		$back.animation=type
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	#Flags.entered.active=false
	
	
