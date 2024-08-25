extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var has_berry = false
var can_double_jump = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if has_berry == true:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump == true:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
		if is_on_floor():
			can_double_jump = true
		
	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
				
	# Play animations
	# plays death animation if engine speed is halved, only happens when killzone is hit
	if Engine.time_scale == 0.5:
		animated_sprite.play("dead")
	
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
