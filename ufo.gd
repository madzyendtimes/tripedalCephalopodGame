extends Area2D
var hp=4
var dead=false
var rot=0.0
var speed=5
var dir=1
var descent=false
var ydir=0
var freefall=false
var ufo=false
var stopit=false

var enemytype=Flags.enemytypes.ufo.duplicate()


func _ready() -> void:
	domoves()
	changegun()

func stop():
	stopit=true

func domoves():
	if dead:
		return
	if Flags.rng.randi_range(0,100)>75:
		descent=true
		ydir=Flags.rng.randi_range(-2,2)
	if Flags.rng.randi_range(0,100)>75:
		dir=dir*-1			
			
	Flags.tne.dotime(self,[domoves],Flags.rng.randf_range(0.5,2.3),"domoves"+str(get_instance_id()),true,"level")

func changegun():
	if dead:
		return
	rot+=min(max(-.75,Flags.rng.randf_range(-.15,.15)),.75)
	$Sprite2D.rotation+=rot
	if Flags.rng.randi_range(0,100)>75:
		Flags.tne.addEvent("laser","level",false,{"pos":position,"rot":$Sprite2D.rotation,"user":false})
	Flags.tne.dotime(self,[changegun],Flags.rng.randf_range(0.3,1.0),"changegun"+str(get_instance_id()),true,"level")


func _process(delta: float) -> void:
	if ufo:
		if stopit:
			return
		if Flags.mode!="spacetime":
			if Flags.special=="ufo":
				if Input.is_action_pressed("down"):
					ydir=1
				if Input.is_action_pressed("up"):
					ydir=-1
				if Input.is_action_pressed("right"):
					dir=-1
				if Input.is_action_pressed("left"):
					dir=1
				if Input.is_action_pressed("run"):
					rot+=.01
					rot=clamp(rot,-1.57,1.57)
					$Sprite2D.rotation=rot
				if Input.is_action_pressed("search"):
					rot-=.01
					rot=clamp(rot,-1.57,1.57)
					$Sprite2D.rotation=rot
				
				if position.y>550:
					ydir=-1
				if position.y<-20:
					ydir=1
				position.y+=ydir*enemytype.speed	
				Flags.tne.addEvent("vehicle","level",true,{"pos":position,"dir":dir,"speed":enemytype.speed})
				if Input.is_action_just_pressed("fight"):
					Flags.tne.addEvent("laser","level",false,{"pos":position,"rot":rot,"user":true})
			return
		if Input.is_action_pressed("left"):
			position.x=clamp(position.x-enemytype.speed,-400,800)
		if Input.is_action_pressed("right"):
			position.x=clamp(position.x+enemytype.speed,-400,800)
		
	if dead:
		return
	if descent:
		if position.y>400:
			ydir=-1
		if position.y<0:
			ydir=1
	if freefall:
		ydir=5
		if position.y>500:
			freefall=false
			dead=true
			Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
	position.x+=dir*enemytype.speed
	position.y+=ydir

func getufo():
	pass


func _on_body_entered(body: Node2D) -> void:
	if dead==true && !Flags.special=="ufo"&& !Flags.wasufo:
		if body.scale.x<.85:
			Flags.special="ufo"
			self.reparent(body.get_parent(),false)
			self.position.x=body.position.x
			Flags.vehicle=self
			ufo=true
			Flags.wasufo=true
		return
	if body.name.find("liltrip")>-1:
		if body.state=="attack":
			hit()
		return
	if body.name.find("bullet")>-1:
		hit()
		body.hit()
		return
	if Flags.hat=="beg":
		#var begsuccess=Flags.beg(begchance)
		return
	if Flags.inFight==true:
		hit()
		return
	if !ufo:
		body.hit(enemytype)

	
	
	
func hit(dmg=1):

	var tween:=get_tree().create_tween()
	var oldy=position.y
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),position.y-100), .3)
	tween.tween_property($".", "position", Vector2( position.x+(300*Flags.dir*-1),oldy), .3)
	enemytype.hp=Flags.calchits(enemytype.hp)
	if enemytype.hp<1:
		freefall=true		
		$AnimatedSprite2D.animation="dead"
		$Sprite2D.rotation=0
		rot=0
