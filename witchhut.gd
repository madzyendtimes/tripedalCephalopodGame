extends Node2D
var freshstart=true
var playerdead=false
var home=self
var ingredients=["eye","mouth","hair","face","torso","arm","leg","clothes","tongue"]
var rng=RandomNumberGenerator.new()
var stage=4
var recipe=[]
var playerchoice=[{"button":"jump","ingredient":"eye","scene":"","px":100,"py":220,"buttonscene":""},
{"button":"run","ingredient":"mouth","scene":"","px":100,"py":60,"buttonscene":""},
{"button":"search","ingredient":"hair","scene":"","px":320,"py":220,"buttonscene":""},
{"button":"fight","ingredient":"face","scene":"","px":320,"py":60,"buttonscene":""}]
var recipeScene:PackedScene=load("res://recipe.tscn")
var ingScene:PackedScene=load("res://ingredient.tscn")
var inpScene:PackedScene=load("res://inputbutton.tscn")
var ouch=false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Flags.mode!="witchhut" or playerdead:
		return
	if Input.is_action_pressed("enter"):
		resetinput()
	
	for i in playerchoice:
		if Input.is_action_just_pressed(i.button):
			commit(i)
	
	
	match Flags.witchevents:
		"newrecipe":
			createrecipe()
			playerchoices()
			
	Flags.witchevents=""
	pass


func poorchoice():
	var ing=ingScene.instantiate()
	ing.position.x=700
	ing.settype(getrandomingredient())
	ing.drop()
	$ingredients.add_child(ing)
	ouch=true	
	

func goodchoice(pc):
	print("congrats");
	var ing=ingScene.instantiate()
	ing.position.x=700
	ing.settype(pc.ingredient)
	ing.drop()
	$ingredients.add_child(ing)
	Flags.megaStats.gems+=1

func commit(pc):
	pc.buttonscene.press()
	var found=false
	$witchplayer.press()
	var count=0
	for i in recipe:
		if pc.ingredient==i.type:
			goodchoice(pc)
			i.queue_free()
			recipe.remove_at(count)
			if recipe.size()<1:
				recipecomplete()
			found=true			
			break
		count+=1
	if !found:
		poorchoice()


func recipecomplete():
	
	Flags.megaStats.gems+=stage	
	stage+=1
	createrecipe()
	


func resetinput():
	if freshstart:
		return
	for i in playerchoice:
		i.ingredient=getrandomingredient()
		i.scene.settype(i.ingredient)
	pass

func createrecipe():
	$necrowitch/AnimatedSprite2D.animation="rip"
	var count=0
	for i in range(0,stage):
		var choice=rng.randi_range(0,8)
		var reciperender=recipeScene.instantiate()
		if i%3==0:
			count=0
		var rx=860+(100*count)
		var ry=200 +floor(i/3)*100
#		reciperender.scale.x=.01
#		reciperender.scale.y=.01
		#reciperender.position.x=1080
		#reciperender.position.y=640
		reciperender.position.x=rx
		reciperender.position.y=ry
		#var tween=get_tree().create_tween()
		#tween.tween_property(reciperender,"position.x",rx,1)
		#tween.tween_property(reciperender,"position.y",ry,1)
		reciperender.settype(ingredients[choice])
		count+=1
				
		recipe.append(reciperender)
		
#		tween.parallel().tween_property(reciperender,"scale.x",1,.5)
#		tween.parallel().tween_property(reciperender,"scale.y",1,.5)

	Flags.dotime(witchread,0.5)

func witchread():
		for i in recipe:
			$recipes.add_child(i)
		$necrowitch/AnimatedSprite2D.animation="read"


func getrandomingredient():
	return ingredients[rng.randi_range(0,ingredients.size()-1)]	

func randomizechoices():
	for i in playerchoice:
		var ing=getrandomingredient()
		i.ingredient=ing
		i.scene.settype(ing)


func playerchoices():
	
	for i in playerchoice:
		var ing=ingScene.instantiate()
		ing.position.x=i.px
		ing.position.y=i.py
		i.scene=ing
		$playerinput.add_child(ing)
		var inputbutton=inpScene.instantiate()
		inputbutton.position.x=i.px
		inputbutton.position.y=i.py
		i.buttonscene=inputbutton
		inputbutton.settype(i.button)
		$playerinput.add_child(inputbutton)
	freshstart=false
	randomizechoices()

		
func start(callee):
	Flags.mode="witchhut"
	home=callee
	$music.play()

func exit():
	$music.stop()
	#home.exit()

func _on_exit_body_entered(body: Node2D) -> void:
	exit()


func _on_music_finished() -> void:
	$music.play()
	




func _on_cauldrenfront_body_entered(body: Node2D) -> void:
	$soup.splash()
	body.queue_free()
	if ouch:
		ouch=false
		$punish.punish()
		Flags.playerStats.health-=1
		$witchplayer.hit()
		if Flags.playerStats.health<1:
			playerdead=true
		pass
	 # Replace with function body.
