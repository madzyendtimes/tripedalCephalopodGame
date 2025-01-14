extends CharacterBody2D

var hp=4
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dead=false
var inhit=false

func _ready() -> void:
	$AnimatedSprite2D.play()
	#Flags.vol($playerhit,"fx",9)

func start():
	hp=4
	dead=false
	inhit=false
	$AnimatedSprite2D.animation="default"


func addgems():
	var gem=Flags.rng.randi_range(15,75)
	Flags.megaStats.gems+=gem
	$status.visible=true
	$status/stattext.text="+"+str(gem)
	Flags.tne.dotime(self,[killstat],.5,"statspace",true,"level")


func killstat():
	$status.visible=false

func hit():
	if inhit:
		return
	#Flags.pitch($playerhit)
	Flags.play("spaceplayerhit")
#	$playerhit.play()
	hp-=1
	if hp<1:
		rotation=1.27
		dead=true
		return
	$AnimatedSprite2D.animation="d"+str(hp)
	if !inhit:
		inhit=true
		var tween=get_tree().create_tween()
		var posy=position.y
		tween.tween_property(self,"position.y",posy+150,.5)
		tween.tween_property(self,"position.y",posy,.5)
		inhit=false
