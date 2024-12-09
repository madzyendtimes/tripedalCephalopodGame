extends StaticBody2D
var lastbody=self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	var gbo=$Area2D.get_overlapping_bodies()
#	if gbo.size()<1 && lastbody!=self:
#		lastbody.free=true
	#	lastbody=self
	##	return
		
#	for i in gbo:
	#	i.revert()
	#	i.free=false
	#	lastbody=i


func _on_area_2d_body_entered(body: Node2D) -> void:
	#body.revert()
	pass # Replace with function body.
