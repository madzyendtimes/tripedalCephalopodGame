extends Node2D
var rot=.2
var choice="tentacle"
var active=true
var downspin=false
var fps=10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print(Flags.megaStats)
	for i in Flags.megaStats.attackmode:
		if (i=="fist") :
			i="tentacle"
#		print(i)
		if Flags.megaStats.attackmode[i]:
			Flags.amode.append(i)
	for i in range(1,9):
		var c=Flags.rng.randi_range(0,Flags.amode.size()-1)
		get_node("wheel/board/sel"+str(i)+"/sel").animation=Flags.amode[c]
	self.visible=false
#	print(Flags.amode , Flags.amode.size())
	if Flags.amode.size()>1:
		start()

func start():
	if Flags.amode.size()>1:
		self.visible=true
		Flags.tne.dotime(self,[dospin],Flags.rng.randf_range(.01,.25),"dospin",true,"level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !downspin:
		$wheel.rotation+=rot
		$chose.animation=choice

#	if Input.is_action_just_pressed("jump"):
#		dospin()

func hideself():
	self.visible=false

func dospin():
	rot-=.01
	$needlechoice/AnimatedSprite2D.speed_scale-=.02
	if rot<=0.0:
		$needlechoice/AnimatedSprite2D.animation="stop"
#		print("winner : ",choice)
		if choice=="tentacle":
			choice=""
		Flags.fightmode=choice
		Flags.tne.dotime(self,[hideself],.5,"hideself",true,"level")
		downspin=true
		return
	Flags.tne.dotime(self,[dospin],.5,"dospin",true,"level")

func _on_sel_1_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel1/sel.animation


func _on_sel_2_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel2/sel.animation

func _on_sel_3_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel3/sel.animation

func _on_sel_4_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel4/sel.animation


func _on_sel_5_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel5/sel.animation

func _on_sel_6_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel6/sel.animation

func _on_sel_7_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel7/sel.animation

func _on_sel_8_body_entered(body: Node2D) -> void:
	choice=$wheel/board/sel8/sel.animation
