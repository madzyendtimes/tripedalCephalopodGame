extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func foundQuest():

	$AnimatedSprite2D.animation="leggy"
	$AnimatedSprite2D.flip_h=true
	$Text1.animation="questComplete"
	Flags.playerStats.maxHealth+=1
	Flags.playerStats.health=Flags.playerStats.maxHealth


func _on_body_entered(body: Node2D) -> void:
	
	var npcName:String=$AnimatedSprite2D.animation
	var count=0
	if npcName in Flags.Quests:
		
		var objective=Flags.Quests[npcName].objective
		for x in Flags.playerInventory:
			print(x.type,x.item)
			if (x.type==objective[0] && x.item==(objective[1])):
				foundQuest();
				Flags.playerInventory.remove_at(count)
			count+=1
