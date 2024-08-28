extends CharacterBody2D


const SPEED: float = 130.0
const JUMP_VELOCITY: float = -300.0
const DOUBLE_JUMP_VELOCITY: float = -400.0
var alive: bool = true
var berries: int = 0
var can_double_jump: bool = true
var roll: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound


func _physics_process(delta: float) -> void:
	# Get the input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")	# Add the gravity.
	
	# apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	handle_jump()
	flip_sprite(direction)
	play_animations(direction)
	apply_movement(direction)
	
func handle_jump():
	if alive == true:
		if berries == 1:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_sound.play()
			if Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump == true:
				roll = true
				velocity.y = JUMP_VELOCITY
				jump_sound.play()
				can_double_jump = false
			if is_on_floor():
				can_double_jump = true
				roll = false
			
		elif berries >= 2:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_sound.play()
			if Input.is_action_just_pressed("jump") and not is_on_floor() and can_double_jump == true:
				roll = true
				velocity.y = DOUBLE_JUMP_VELOCITY
				jump_sound.play()
				can_double_jump = false
			if is_on_floor():
				can_double_jump = true
				roll = false
		else:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_sound.play()

func flip_sprite(dir):
	if alive == true:
		if dir > 0:
			animated_sprite.flip_h = false
		elif dir < 0:
			animated_sprite.flip_h = true

func play_animations(dir):
	if alive == false:
		animated_sprite.play("dead")
	
	elif is_on_floor():
		if dir == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	else:
		if roll == false:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("roll")
			
func apply_movement(dir):
	if dir and alive == true:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
