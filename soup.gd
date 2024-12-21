extends Node2D

var wait=false


func ouch():
	$AnimatedSprite2D.animation="ouch"
	Flags.tne.dotime(self,[calm],0.5,"calmsoup",true,"temple")

func complete():
	wait=true
	$AnimatedSprite2D.animation="gem"
	Flags.tne.dotime(self,[completecalm],1.0,"completecalmsoup",true,"temple")


func completecalm():
	Flags.witchevents="gemmonster"
	wait=false
	calm()


func calm():
	if !wait:
		$AnimatedSprite2D.animation="calm"

func splash():
	if !wait:
		$AnimatedSprite2D.animation="splash"
		Flags.tne.dotime(self,[calm],0.5,"calmsoup",true,"temple")
