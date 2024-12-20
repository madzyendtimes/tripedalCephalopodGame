extends TextureProgressBar



func _process(delta: float) -> void:
	var ev=Flags.tne.consumeEvent("health")
	if ev!= null:
		match ev.name:
			"update":
				value=Flags.playerStats.health
			"max":
				max_value=Flags.playerStats.maxHealth
		
