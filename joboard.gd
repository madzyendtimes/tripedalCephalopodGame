extends Node2D

var selected=0
var newselect=0
var choices=[]
var jobs=[{"text":"Level pi pipe reconstructering meticulator","applied":false},
	{"text": "unprocessed tomato bifurcation inspector","applied":false},
	{"text": "experienced prance director","applied":false},
	{"text":"deacon of undigested leakage cleanup","applied":false},
	{"text":"sand grain accountant","applied":false},
	{"text":"job joard ai wrangler","applied":false},
	{"text":"professional sushing assistant","applied":false},
	{"text":"entry level cannibal materials proider","applied":false},
	{"text":"children's reeducation camp councellor","applied":false},
	{"text":" spelllling profreading assestnt","applied":false},
	{"text":"standing desk seat warmer","applied":false},
	{"text":"combat knife test subject","applied":false},
	{"text":"suicide evangelist","applied":false},
	{"text":"homelessness field study ethongraphist","applied":false},
	{"text":"literal button pusher: hazard pay available","applied":false},
	{"text":"podcast misinformation whisperer","applied":false},
	{"text":"CEO : telegram inquiries only","applied":false},
	{"text":"entry level advanced cryonics instructor","applied":false}
	]

var attributes=["evil","stanima","health","speed","power","gems","smarts","rizz","dark triad inclination","cult indoctrination","desperation","obediance","etsablishment","gullibility","existential dread","teenage angst","pleasant oder","expendibility","obsequienceness","or less","blandness","extravegance","team sports","shut in","colonialism","unspeakable horror","reverance for authority"]
var responses=["Thank you for your application.\n unfortunately we are looking for a candidate with more {0}"
	,"We have received your application.\n  Nice try but you don't even have enough {0}"
	,"Don't waste my time.\n  We're only looking at people with at least SOME {0}"
	,"try brushing up on your {0}. better luck next time"
	,"sorry but you've got too much {0}"
	,"We liked your qualifications and want to hire you, unfortunately we just shut down the {0} department"]

var stamps=[]
var lazy=[]

func _ready() -> void:
	$music.play()
	jobs.shuffle()
	for i in range(0,9):
		var h=HBoxContainer.new()
		var st=$stamp.duplicate()
		
		var l=Label.new()
		var display=jobs.pop_back()
		l.text=display.text
		$CanvasLayer/VBoxContainer.add_child(h)
		h.add_child(l)
		h.add_child(st)
		st.position.y+=Flags.rng.randi_range(-8,8)
		st.position.x+=Flags.rng.randi_range(-8,8)
		st.rotation+=Flags.rng.randf_range(-.25,.25)
		st.visible=false
		choices.append(l)
		stamps.append(st)
		lazy.append(display)
	Flags.mode="jobboard"
	selectjob()

func _process(delta: float) -> void:
	if Flags.mode!="jobboard":
		return
	if Input.is_action_just_pressed("enter"):
		newselect=max(0,newselect-1)
		selectjob()
	
	if Input.is_action_just_pressed("down"):
		newselect=min(9,newselect+1)
		selectjob()
	
	if Input.is_action_just_pressed("jump"):
		applyjob()
	


	
func selectjob():
	choices[selected].set("theme_override_constants/outline_size",0)
	choices[newselect].set("theme_override_constants/outline_size",4)
	selected=newselect

func applyjob():
	$buzzer.pitch_scale=Flags.rng.randf_range(0.7,1.3)
	$buzzer.play()
	choices[selected].set("theme_override_colors/font_color",Color.RED)
	stamps[selected].visible=true
	attributes.shuffle()
	var at=attributes.pop_back()
	$CanvasLayer/AnimatedSprite2D.animation="reject"
	responses.shuffle()
	$CanvasLayer/response/reject.text=responses[0].format([at])
	if 	lazy[selected].applied:
		$CanvasLayer/response/reject.text="Are you stupid? I'm glad I rejected you for this job already"
	$CanvasLayer/response.visible=true
	lazy[selected].applied=true
	Flags.tne.dotime(self,[hidetext],3.5,"hidetext",true,"jobboard")
	
	
func hidetext():
	$CanvasLayer/AnimatedSprite2D.animation="reject"
	$CanvasLayer/response.visible=false
	
	
	


func _on_music_finished() -> void:
	$music.play()
