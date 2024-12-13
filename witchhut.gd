extends Node2D

var home=self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start(callee):
	home=callee
	$music.play()

func exit():
	$music.stop()
	home.exit()

func _on_exit_body_entered(body: Node2D) -> void:
	exit()


func _on_music_finished() -> void:
	$music.play()
	pass # Replace with function body.
