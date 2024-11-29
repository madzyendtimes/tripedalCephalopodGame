extends Area2D

var allreadyentered=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start():
	$"../../locationfront/tutorial/cryptominos".start()

func close():
	$front.animation="cryptominosentered"
	
	
func _on_body_entered(body: Node2D) -> void:

	print("enterable")
	Flags.entered.ready=true
	Flags.entered.building=self
	Flags.entered.type=$front.animation
		
	


func _on_body_exited(body: Node2D) -> void:
	print("unenterable")
	Flags.entered.ready=false
	#Flags.entered.active=false
	
	
