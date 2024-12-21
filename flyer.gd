extends Area2D
var prizeScene:PackedScene=load("res://prize.tscn")
var missle:PackedScene=load("res://eggmissle.tscn")
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
var crashed:=false
var runningaway:=false
var freefall:=false
var begchance=40
var hasmissle=true

func _ready() -> void:
	selectType()


func selectType():
	var choice:=rng.randi_range(0,2)
	if choice==0:
		$AnimatedSprite2D.animation="bug"
		type="bug"
		maxspd=5.0
		minchange=0.5
		maxchange=1.5
		minspd=2.0
		hasmissle=false
	if choice==1:
		$AnimatedSprite2D.animation="drone"
		type="drone"
		maxspd=4.0
		minchange=1.0
		maxchange=2.0
		minspd=1.0
		canflip=false
		hasmissle=false
	Flags.tne.dotime(self,[changedirection],1.0,"changedirection"+str(self.get_instance_id()),true,"level")
	
	if hasmissle:
		
		Flags.tne.dotime(self,[dropmissle],rng.randf_range(0.5,5.0),"dropmissle"+str(self.get_instance_id()),true,"level")

func dropmissle():
		var egg=missle.instantiate()
		egg.position.y=position.y
		egg.position.x=position.x
		self.get_parent().add_child(egg)
#	

		Flags.tne.dotime(self,[dropmissle],rng.randf_range(0.5,5.0),"dropmissle"+str(self.get_instance_id()),true,"level")


func _process(delta):
	
	if Flags.paused==true:
		return
		
	if type=="drone":
		if crashed==true  && freefall==true:
			position.y+=7
			if position.y>500:
				freefall=false
				showprize()
			return
	if crashed==true:
		return	
	if Flags.horror==false:
		position.x-=spd*dir
		position.y=ypos

func showprize():
	var prize=prizeScene.instantiate()
	var version=rng.randi_range(1,7)
	prize.animation="collectable"+str(version)
	Flags.addToInventory(4,version)
	add_child(prize)

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


	Flags.tne.dotime(self,[changedirection],nxtchange,"changedirection"+str(self.get_instance_id()),true,"level")


func runaway():
	if runningaway==false:
		runningaway=true
		dir=dir*-1


		Flags.tne.dotime(self,[recourage],3.0,"recourage"+str(self.get_instance_id()),true,"level")
		$AnimatedSprite2D.flip_h=true

func recourage():
	runningaway=true
	dir=dir*-1
	$AnimatedSprite2D.flip_h=false

func getpackage():
	crashed=true
	freefall=true
	$AnimatedSprite2D.animation=type+"crashed"
	

func _on_body_entered(body: Node2D) -> void:
	if Flags.hat=="beg":
		var begsuccess=Flags.beg(begchance)
		return
	if Flags.credit==true and type=="drone":
		getpackage()
		return
	
	Flags.effect="hit"
