extends TextureProgressBar

func _ready() -> void:
	max_value=Flags.playerStats.maxStanima
	value=Flags.playerStats.stanima
	

func _process(delta: float) -> void:
	var ev=Flags.tne.consumeEvent("stanima")
	if ev!= null:
		match ev.name:
			"update":
				value=Flags.playerStats.stanima
			"max":
				max_value=Flags.playerStats.maxStanima
		
