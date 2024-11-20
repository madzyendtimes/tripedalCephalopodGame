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
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation=chesttype+"closed"	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
			$trash.play()
			notSearched=false
			$AnimatedSprite2D.animation=chesttype+"search"
			var tween = get_tree().create_tween()
			$AnimatedSprite2D.animation=chesttype+"search"
			var oldmod=$AnimatedSprite2D.modulate
			tween.tween_property($AnimatedSprite2D, "modulate", oldmod, .5)
			tween.tween_callback(searched)

func _on_body_exited(body):
	searchable=false
	
	
	pass # Replace with function body.

func show_prize():
	var rng=RandomNumberGenerator.new()
	type=rng.randi_range(0,1)
	if questItem==true:
		type=2	
	if type>types.size()-1:
		type=0

	if deterministic==true:
		type=ptype	
	var name=types[type].name
	var numvariant=types[type].num
	var ts=$Sprite2D
	var treenum=rng.randi_range(1,numvariant)
	if deterministic==true:
		treenum=pvar
	var istr="res://"+name+"text"+str(treenum)+".PNG"
	var image = Image.load_from_file(istr)

	var texture = ImageTexture.create_from_image(image)
	ts.texture = texture
	Flags.addToInventory(type,treenum)
	add_child(ts)
	if questItem==true:
		$questfound.play()




func _on_body_entered(body):
	searchable=true
	trashable.emit()
