extends Node2D
var type=""


func settype(ptype):
	
	type=ptype
	$AnimatedSprite2D.animation=ptype
	
