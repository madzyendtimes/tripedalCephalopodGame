extends Node2D

var type:="tv"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chooseType()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if type=="tvhorror":
		if $active.get_overlapping_areas().size()>0:
			for enemy in $active.get_overlapping_areas():
				enemy.runaway()
				
	pass

func settype(ptype):
	type=ptype
	$active/AnimatedSprite2D.animation=ptype

func chooseType():
	var rng:=RandomNumberGenerator.new()
	var t:=rng.randi_range(0,2)
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
			Flags.effect="mesmerized"
		if type=="eyes":
			Flags.effect="controlled"
	else:
		Flags.effect="resisted"	


func _on_active_body_exited(body: Node2D) -> void:
	if Flags.mesmerized:
		Flags.mesmerized=false
		Flags.effect="normal"
	if Flags.controlled:
		Flags.controlled=false
		Flags.effect="normal"
	
