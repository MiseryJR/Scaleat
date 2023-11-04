extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var size_scale = 1
const SCALE_RATE = 0.1


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		$Sprite.play("eat")
		$EatCollision.disabled = false
		$NormalCollision.disabled = true
	elif event is InputEventMouseButton and event.is_released():
		$Sprite.play("default")
		$EatCollision.disabled = true
		$NormalCollision.disabled = false
	elif event is InputEventKey and event.as_text_key_label() == "Shift":
		size_scale += SCALE_RATE
		scale = Vector2(scale.x+SCALE_RATE, scale.y+SCALE_RATE)
		print("shift")
	elif event is InputEventKey and event.as_text_key_label() == "Ctrl":
		if (size_scale - SCALE_RATE) >= 1:
			size_scale -= SCALE_RATE
			scale = Vector2(scale.x-SCALE_RATE, scale.y-SCALE_RATE)
		print("control")

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY - (size_scale*10)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * (SPEED + (size_scale*10))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED + (size_scale*10))

	move_and_slide()
