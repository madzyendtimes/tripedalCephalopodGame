extends Area2D

var dir:=-1
var spd:=2.5
var ypos:=0
var minspd:=1.5
var maxchange:=5.0
var maxspd:=3.0
var minchange:=1.0
var canflip:=true
var rng=RandomNumberGenerator.new()
var type:="default"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selectType()

	pass # Replace with function body.


func selectType():
	var choice:=rng.randi_range(0,2)
	if choice==0:
		$AnimatedSprite2D.animation="bug"
		type="bug"
		maxspd=5.0
		minchange=0.5
		maxchange=1.5
		minspd=2.0
	if choice==1:
		$AnimatedSprite2D.animation="drone"
		type="drone"
		maxspd=4.0
		minchange=1.0
		maxchange=2.0
		minspd=1.0
		canflip=false
	dotime(changedirection,1.0)

func _process(delta):
	
	if Flags.paused==true:
		return
	
	if Flags.horror==false:
		position.x-=spd*dir
		position.y=ypos

func changedirection():

	var tdir=rng.randi_range(0,1)
	if tdir==0:
		tdir=-1
	dir=dir*tdir
	if dir>0 || canflip==false:
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true

	spd=rng.randf_range(minspd,maxspd)
	ypos=rng.randi_range(-5,5)
	var nxtchange=rng.randf_range(minchange,maxchange)
	dotime(changedirection,nxtchange)

func dotime(timefunc,ntime):
	var gt:Timer=Timer.new()
	add_child(gt)
	gt.wait_time=ntime
	gt.one_shot=true			
	gt.timeout.connect(timefunc)
	gt.start()

func getpackage():
	self.queue_free()
	#Flags.effect="prize"


func _on_body_entered(body: Node2D) -> void:
	if Flags.hat=="beg":
		return
	if Flags.credit==true and type=="drone":
		getpackage()
		return
	
	Flags.effect="hit"
