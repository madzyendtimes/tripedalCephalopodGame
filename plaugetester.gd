extends "res://basemonster.gd"

func _ready():
	enemytype=Flags.enemytypes.plaugetestor.duplicate()
	createGas()

func createGas():
	Flags.tne.addEvent("gas","level",false,{"pos":position.x})
	Flags.tne.dotime(self,[createGas],Flags.rng.randf_range(.2,1.5),"makegas"+str(get_instance_id()),false,"level")

func ondead():
	Flags.tne.killTimer("makegas"+str(get_instance_id()),"level")
	

		
