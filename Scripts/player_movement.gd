extends CharacterBody2D

@export var walk_speed: float = 200
@export var dash_multiplier: float = 4.0
@export var dash_duration: float = 0.10
@export var dash_cooldown: float = 1   # cooldown in seconds

var input_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO   # store dash direction
var base_speed: float
var dash_cooldown_timer: float = 0.0   # tracks cooldown

func _ready() -> void:
	base_speed = walk_speed

func _physics_process(delta: float) -> void:
	# Update cooldown
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

	# Get input
	input_direction.x = Input.get_axis("move_left", "move_right")
	input_direction.y = Input.get_axis("move_up", "move_down")
	input_direction = input_direction.normalized()

	# Start dash (only if not cooling down)
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0.0 and input_direction != Vector2.ZERO:
		is_dashing = true
		dash_timer = dash_duration
		dash_direction = input_direction   # lock dash direction
		dash_cooldown_timer = dash_cooldown   # start cooldown

	# Dash logic
	if is_dashing:
		velocity = dash_direction * (base_speed * dash_multiplier)
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
	else:
		# Instant walk movement
		velocity = input_direction * base_speed

	# Flip sprite (make sure node is named "sprite" or update to your AnimatedSprite2D name)
	if input_direction.x > 0:
		%sprite.flip_h = false
	elif input_direction.x < 0:
		%sprite.flip_h = true

	# Animation
	if is_dashing:
		%sprite.play("dash")
	elif input_direction != Vector2.ZERO:
		%sprite.play("walking")
	else:
		%sprite.play("idle")

	move_and_slide()
