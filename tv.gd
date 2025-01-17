extends Node2D

var type:="tv"


func _ready() -> void:
	chooseType()

func _process(delta: float) -> void:
	if type=="tvhorror":
		if $active.get_overlapping_areas().size()>0:
			for enemy in $active.get_overlapping_areas():
				enemy.runaway()
				

func settype(ptype):
	type=ptype
	$active/AnimatedSprite2D.animation=ptype

func chooseType():

	var t=Flags.rng.randi_range(0,2)
	if t>1:
		type="eyes"
		$active/AnimatedSprite2D.animation=type
		return
	if t>0:
		type="tvhorror"
		$active/AnimatedSprite2D.animation=type
		return
	
func _on_active_body_entered(body: Node2D) -> void:
	
	if Flags.hat!="that":
		if type=="tv":
			Flags.tne.addEvent("mesmerized","level")
			#Flags.effect="mesmerized"
		if type=="eyes":
			Flags.tne.addEvent("controlled","level")
			#Flags.effect="controlled"
	else:
		Flags.tne.addEvent("resisted","level")
		#Flags.effect="resisted"	

func hit(dmg=1):
		type="tvhorror"
		$active/AnimatedSprite2D.animation=type
		return


func _on_active_body_exited(body: Node2D) -> void:
	if body.name.find("bullet")>-1:
		hit()
		body.hit()
		return
	
	if Flags.mesmerized:
		Flags.mesmerized=false
		#Flags.effect="normal"
		Flags.tne.addEvent("normal","level")
	if Flags.controlled:
		Flags.controlled=false
		#Flags.effect="normal"
		Flags.tne.addEvent("normal","level")
