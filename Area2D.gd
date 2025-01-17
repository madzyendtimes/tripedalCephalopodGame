extends Area2D
var notSearched:=true
var searchable:=false
var questItem:=false
var types=Flags.types
var type:=0
signal trashable
var chesttype=""
var ptype:=0
var pvar:=0
var deterministic:=false

func _ready():
	$AnimatedSprite2D.animation=chesttype+"closed"	
#	$questfound.volume_db=Flags.options.fx
#	$trash.volume_db=Flags.options.fx
	$prize.animation="default"

func _process(delta):
	if Flags.paused==true:
		return	
	if searchable==true && Flags.inSearch==true && notSearched==true:
		do_search();
	
func setType(ctype):
	chesttype=ctype
	$AnimatedSprite2D.animation=chesttype+"closed"	

func setItem(n,v):
	ptype=n
	pvar=v
	deterministic=true

func searched():
		$AnimatedSprite2D.animation=chesttype+"open"
		show_prize()
		
func do_search():
		
		if $AnimatedSprite2D.animation==chesttype+"closed":
			Flags.play("trash")
			#$trash.play()
			notSearched=false
			$AnimatedSprite2D.animation=chesttype+"search"
			var tween = get_tree().create_tween()
			$AnimatedSprite2D.animation=chesttype+"search"
			var oldmod=$AnimatedSprite2D.modulate
			tween.tween_property($AnimatedSprite2D, "modulate", oldmod, .5)
			tween.tween_callback(searched)

func _on_body_exited(body):
	searchable=false

func show_prize():
	type=Flags.rng.randi_range(0,2)
	if questItem==true:
		type=3	
	if type>types.size()-1:
		type=0

	if deterministic==true:
		type=ptype	
	var name=types[type].name
	var numvariant=types[type].num

	var ts=$Sprite2D
	var treenum=Flags.rng.randi_range(1,numvariant)
	if deterministic==true:
		treenum=pvar
	$prize.animation=types[type].type+str(treenum)
	Flags.addToInventory(type,treenum)
	
	if questItem==true:
		Flags.play("questfound")
#		$questfound.play()

func _on_body_entered(body):
	searchable=true
	trashable.emit()

func hit(dmg=1):
	pass
