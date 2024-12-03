extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Flags.weather=""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeweather():
	var rng=RandomNumberGenerator.new()
	var type=rng.randi_range(0,3)
	match type:
		0:
			Flags.weather="rain"
		1:
			Flags.weather="sun"
		2:
			Flags.weather="night"
		3:
			Flags.weather="snow"
		_:
			#use current weather
			pass
	
	
	$AnimatedSprite2D.animation=Flags.weather
