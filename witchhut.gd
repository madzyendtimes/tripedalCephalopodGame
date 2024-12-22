extends Node2D
var freshstart=true
var playerdead=false
var home=self
var ingredients=["eye","mouth","hair","face","torso","arm","leg","clothes","tongue"]
var stage=4
var recipe=[]
var playerchoice=[{"button":"jump","ingredient":"eye","scene":"","px":100,"py":220,"buttonscene":""},
{"button":"run","ingredient":"mouth","scene":"","px":100,"py":60,"buttonscene":""},
{"button":"search","ingredient":"hair","scene":"","px":320,"py":220,"buttonscene":""},
{"button":"fight","ingredient":"face","scene":"","px":320,"py":60,"buttonscene":""}]
var recipeScene:PackedScene=load("res://recipe.tscn")
var ingScene:PackedScene=load("res://ingredient.tscn")
var inpScene:PackedScene=load("res://inputbutton.tscn")
var gemScene:PackedScene=load("res://gemmonster.tscn")
var ouch=false
var timetext=30


func _ready() -> void:
	$music.volume_db=Flags.options.music
	#start(self)

func hidegems():
	$gems.visible=false


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
		"gemmonster":
			var gm=gemScene.instantiate()
			gm.position=Vector2(600,550)
			$monsters.add_child(gm)
			$gems/Label.text="+"+str(stage)
			$gems.visible=true
			Flags.tne.dotime(self,[hidegems],1.0,"hidegems",true,"witchhut")
		"gemcaught":
			Flags.megaStats.gems+=stage	
			Flags.save()
			stage+=1
			
			createrecipe()
	Flags.witchevents=""



func poorchoice(ingredient):
	var ing=ingScene.instantiate()
	ing.position.x=650
	ing.settype(ingredient)
	ing.drop()
	$ingredients.add_child(ing)
	ouch=true	
	

func goodchoice(pc):
	#print("congrats");
	var ing=ingScene.instantiate()
	ing.position.x=650
	ing.settype(pc.ingredient)
	ing.drop()
	$ingredients.add_child(ing)
	#Flags.megaStats.gems+=1

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
		poorchoice(pc.ingredient)


func recipecomplete():
	$time.visible=false
	$soup.complete()

	
func clearinput():
	for i in playerchoice:
		if is_instance_valid(i.scene):
			i.scene.queue_free()
		if is_instance_valid(i.buttonscene):
			i.buttonscene.queue_free()
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
		var choice=Flags.rng.randi_range(0,8)
		var reciperender=recipeScene.instantiate()
		if i%3==0:
			count=0
		var rx=860+(100*count)
		var ry=200 +floor(i/3)*100
		reciperender.position.x=rx
		reciperender.position.y=ry
		reciperender.settype(ingredients[choice])
		count+=1		
		recipe.append(reciperender)
		$recipes.add_child(reciperender)
		dotweens(rx,ry,reciperender)

	timetext=30+(stage*3)
	$time/Label.text=str(timetext)
	$time.visible=true
	Flags.tne.dotime(self,[counter],1.0,"counter",true,"witchhut")
	Flags.tne.dotime(self,[witchread],0.5,"witchread",true,"witchhut")

func clearrecipe():

	for i in recipe:
		if is_instance_valid(i):
			i.queue_free()
	for i in recipe:
		recipe.remove_at(0)
	$time.visible=false


func counter():
	timetext-=1
	$time/Label.text=str(timetext)
	if timetext<1 && $time.visible==true:
		poorchoice(getrandomingredient())
		clearrecipe()
		createrecipe()
		return
	if $witchplayer.engaged:
		Flags.tne.dotime(self,[counter],1.0,"counter",true,"witchhut")
func dotweens(px,py,reciperender):
		var tween=get_tree().create_tween()
		reciperender.scale=Vector2(0.1,0.1)
		reciperender.position.x=1080
		reciperender.position.y=640
		tween.parallel().tween_property(reciperender,"position",Vector2(px,py),1)
		tween.parallel().tween_property(reciperender,"scale",Vector2(1,1),1)

func witchread():
		

		$necrowitch/AnimatedSprite2D.animation="read"


func getrandomingredient():
	return ingredients[Flags.rng.randi_range(0,ingredients.size()-1)]	

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
	Flags.witchevents=""
	Flags.mode="witchhut"
	home=callee
	$music.play()
	recipe=[]

func exit(isdead=false):
	clearrecipe()
	clearinput()
	freshstart=true
	$music.stop()
	home.exit(isdead)

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
			exit(true)



func _on_button_body_exited(body: Node2D) -> void:
	clearrecipe()
	clearinput()
