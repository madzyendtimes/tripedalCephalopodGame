extends Node2D
var dmg=5
var chances=[35,35,30]
var demolished=false
var enemytype=Flags.enemytypes.gravestone.duplicate()

func _ready() -> void:
	$stone.position.y+=Flags.rng.randi_range(-20,20)
	


func debrioff():
	$stone/debri.visible=false



func hit(ouch=1):
	if demolished:
		return
	$stone/debri.visible=true
	Flags.tne.dotime(self,[debrioff],.7,"debrioff"+str(self.get_instance_id()),true,"level")
	dmg=max(1,dmg-1)
	Flags.play("thud")
	$stone/grave.animation="dmg"+str(dmg)
	if dmg==1:
		demolished=true
		$levelghost.kill()
		Flags.tne.addEvent("deadEnemy","level",false,{"type":enemytype})
		return
	var result=Flags.rng.randi_range(0,100)
	var agg=chances[0]
	if result<agg:
		Flags.tne.addEvent("addgems","level")
		return
	agg+=chances[1]
	if result<agg:
		$levelghost.start($stone)
		return



func _on_stone_body_entered(body: Node2D) -> void:
	
	if body.name.find("bullet")>-1||body.name.find("laser")>-1:
		hit()
		body.hit()
		return
	
	
	
	if Flags.inFight && $levelghost!=null:
		hit()			
