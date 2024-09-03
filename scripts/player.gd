extends CharacterBody2D


const SPEED: float = 130.0
const JUMP_VELOCITY: float = -300.0
const DOUBLE_JUMP_VELOCITY: float = -400.0
const DASH_SPEED: float = 500.0
const WALL_JUMP_DIST: float = 300.0
const WALL_SLIDE_FRICTION: float = 50.0


var alive: bool = true
var berries: int = 0
var can_double_jump: bool = true
var roll: bool = false
var can_slide: bool = false
var is_sliding: bool = false
var dashing: bool = false
var can_dash: bool = true
var which_sprite: int = 1


@onready var sprite_1: AnimatedSprite2D = $Sprite1
@onready var sprite_2: AnimatedSprite2D = $Sprite2
@onready var sprite_3: AnimatedSprite2D = $Sprite3
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

var sprite_array = [sprite_1, sprite_2, sprite_3]
var sprite: AnimatedSprite2D = sprite_1


func _physics_process(delta: float) -> void:
	# Get the input direction -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")

	# apply gravity
	if not is_on_floor() and not dashing:
		velocity += get_gravity() * delta
	if not is_on_floor() and dashing:
		velocity.y = 0

	switch_sprite()
	handle_jump()
	if can_slide:
		wall_slide(delta)
	flip_sprite(direction)
	play_animations(direction)
	apply_movement(direction)
	dash()
	
func handle_jump():
	if alive == true:
		if berries == 1:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_sound.play()
			if Input.is_action_just_pressed("jump") and not is_on_floor() and is_sliding == false and can_double_jump == true:
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
			if Input.is_action_just_pressed("jump") and not is_on_floor() and is_sliding == false and can_double_jump == true:
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
				
func wall_slide(delta):
	if is_on_wall_only():
		is_sliding = true
	else:
		is_sliding = false
		
	if is_sliding:
		velocity.y += WALL_SLIDE_FRICTION * delta
		velocity.y = min(velocity.y, WALL_SLIDE_FRICTION)
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
		
		
func flip_sprite(dir):
	if alive == true:
		if dir > 0:
			sprite.flip_h = false
		elif dir < 0:
			sprite.flip_h = true

func play_animations(dir):
	if alive == false:
		sprite.play("dead")
	
	elif is_on_floor():
		if dir == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	
	else:
		if roll == false:
			sprite.play("jump")
		else:
			sprite.play("roll")
			
func apply_movement(dir):
	if dir and alive == true:
		if dashing == false:
			velocity.x = dir * SPEED
		else:
			velocity.x = dir * DASH_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func dash():
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		$dash_again_timer.start()

func switch_sprite():
	sprite.hide()
	sprite = sprite_array[which_sprite]
	sprite.show()

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	can_dash = true
