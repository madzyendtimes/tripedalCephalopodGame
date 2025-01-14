extends Node2D
var selected=1
var home=self
#var options={"controls":"controller","music":100,"fx":100,"randomizeDistribution":false,"seed":{"active":false,"value":"fun"},"startfresh":false,"graphics":"high"}
func _ready():
	Flags.loadoptions()
	print("load options")
	$loading.visible=false
	
	if Flags.titlescreen=="win":
		$Title.animation="win"
	else:
		$Title.animation="title"
	$ui/VBoxContainer.get_child(selected).grab_focus()
	Flags.setvolumes()
	Flags.play("titlemusic","music")	
	#$AudioStreamPlayer2D.volume_db=Flags.options.music
	#$PopupPanel/VBoxContainer.get_child(selected)
	
func populateoptions():

	if Flags.options.controls=="keyboard":
		$optionmenu/VBoxContainer/VBoxContainer/HBoxContainer/keyboard.button_pressed=true
	else:
		$optionmenu/VBoxContainer/VBoxContainer/HBoxContainer/controller.button_pressed=true	
	if Flags.options.graphics=="low":
		$optionmenu/VBoxContainer/VBoxContainer3/HBoxContainer/low.button_pressed=true
	else:
		$optionmenu/VBoxContainer/VBoxContainer3/HBoxContainer/high.button_pressed=true

	if Flags.options.randomizeDistribution:
		$optionmenu/VBoxContainer/VBoxContainer4/HBoxContainer/HBoxContainer/randomizeDistribution.button_pressed=true
	
	if Flags.options.startfresh:
		$optionmenu/VBoxContainer/VBoxContainer4/HBoxContainer/VBoxContainer/HBoxContainer/freshstart.button_pressed=true
		
	$optionmenu/VBoxContainer/VBoxContainer2/VBoxContainer/HBoxContainer2/music.value=Flags.options.music
	$optionmenu/VBoxContainer/VBoxContainer2/HBoxContainer/fx.value=Flags.options.fx
	
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Flags.mode=="optionmenu":
		if Input.is_action_just_pressed("fight"):
			Flags.mode="title"
			$optionmenu.visible=false
			$ui/VBoxContainer/MenuButton2.grab_focus()	

func start(callee):
	home=callee

func loading():
	$loading.visible=true
	Flags.titlescreen="title"


func _on_controller_pressed() -> void:
	Flags.options.controls="controller"
	Flags.saveoptions()
	


func _on_keyboard_pressed() -> void:
	Flags.options.controls="keyboard"
	Flags.saveoptions()
	



func _on_music_value_changed(value: float) -> void:
	Flags.options.music=value
	#$AudioStreamPlayer2D.volume_db=Flags.options.music	
	Flags.setvolumes()

func _on_fx_value_changed(value: float) -> void:
	Flags.options.fx=value
	Flags.setvolumes()


func _on_low_pressed() -> void:
	Flags.options.graphics="low"
	Flags.saveoptions()
	


func _on_high_pressed() -> void:
	Flags.options.graphics="high"
	Flags.saveoptions()
	


func _on_freshstart_toggled(toggled_on: bool) -> void:
	Flags.freshstart=toggled_on
	if toggled_on:
			Flags.defaultmegastats()


func _on_randomize_distribution_toggled(toggled_on: bool) -> void:
	Flags.options.randomizeDistribution=toggled_on



func _on_menu_button_pressed() -> void:
	populateoptions()
	Flags.mode="optionmenu"
	$optionmenu.visible=true
	$optionmenu/VBoxContainer/backtogame.grab_focus()


func _on_backtogame_pressed() -> void:
	Flags.mode="title"
	$optionmenu.visible=false
	Flags.saveoptions()
	$ui/VBoxContainer/MenuButton2.grab_focus()


func _on_audio_stream_player_2d_finished() -> void:
	#$AudioStreamPlayer2D.play()
	pass


func _on_menu_button_2_pressed() -> void:
	loading()
	home.playgame()
