extends CharacterBody2D

@export var movement_speed : float = 500
@export var dash_multiplier: float = 10.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.5

var character_direction : Vector2
var is_dashing: bool = false
var dash_timer: float = 2
var cooldown_timer: float = 0.0

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis('move_up',"move_down")
	character_direction = character_direction.normalized()
	
	if Input.is_action_just_pressed("dash") and not is_dashing and cooldown_timer <= 0:
		is_dashing = true
		dash_timer = dash_duration
		cooldown_timer = dash_cooldown
	
	if is_dashing:
		velocity = character_direction * movement_speed * dash_multiplier
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		velocity = character_direction * movement_speed
		if cooldown_timer > 0:
			cooldown_timer -= delta
	
	
	#flip
	if character_direction.x > 0: %sprite.flip_h = false
	if character_direction.x < 0: %sprite.flip_h = true
	
	if character_direction:
		velocity = character_direction * movement_speed
		if %sprite.animation != "walking": %sprite.animation = "walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %sprite.animation != "idle": %sprite.animation = "idle"
		
	move_and_slide()
