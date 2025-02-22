extends CharacterBody2D


const SPEED = 900.0

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if Flags.mode!="cryptominos":
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Flags.entered.active:# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY-(Flags.playerStats.speed*100)

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * (SPEED+(Flags.playerStats.speed*50))
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED+(Flags.playerStats.speed*50))

		move_and_slide()
