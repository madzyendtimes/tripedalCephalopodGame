extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:

	if Flags.entered.active==true:
		if 	Flags.mode=="cryptominos":
			Flags.cryptoeffects="exit"	

		Flags.paused=false;
		Flags.entered.active=false
	#	Flags.effect="exitenterable"


			#Flags.cryptoeffects="exit"	
