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
