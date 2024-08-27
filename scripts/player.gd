extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var alive = true
var has_berry = false
var can_double_jump = true
var roll = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if alive == true:
		if has_berry == true:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
			if Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump == true:
				roll = true
				velocity.y = JUMP_VELOCITY
				can_double_jump = false
			if is_on_floor():
				can_double_jump = true
				roll = false
			
		else:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY

	# Get the input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if alive == true:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
				
	# Play animations
	if alive == false:
		animated_sprite.play("dead")
	
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	else:
		if roll == false:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("roll")
	
	# Apply movement if alive
	if direction and alive == true:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
