extends Area2D


func _ready() -> void:
	Flags.weather=""

func changeweatherforce():
	var old=Flags.weather
	changeweather()
	if Flags.weather==old:
		changeweatherforce()
	
func changeweather():

	var type=Flags.rng.randi_range(0,4)
	match type:
		0:
			Flags.weather="rain"
		1:
			Flags.weather="sun"
		2:
			Flags.weather="night"
		3:
			Flags.weather="snow"
		4:
			Flags.weather=""
			Flags.tne.addEvent("weatheroff","level",true)
			return
		_:
			#use current weather
			pass
	
	
	$AnimatedSprite2D.animation=Flags.weather
