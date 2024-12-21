extends Node2D
var type=""


func settype(ptype):
	if Flags.controlScheme=="keyboard":
		ptype+="keyboard"
	type=ptype
	$AnimatedSprite2D.animation=ptype
	
func press():
	$AnimatedSprite2D.animation=type+"pressed"
	
	Flags.tne.dotime(self,[unpress],.7,"unpress",false,Flags.mode)
	
func unpress():
	$AnimatedSprite2D.animation=type
