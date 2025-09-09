extends Node2D

@export var bullet_scene: PackedScene   # drag your bullet.tscn here in Inspector
@onready var gun_sprite: Sprite2D = $gun_sprite
@onready var gun_muzzle: Node2D = $GunMuzzle

@export var fire_rate: float = 0.2   # time between shots (seconds)
var shooting: bool = false
var can_shoot: bool = true

@export var mag_size: int = 12          # how many bullets before reload
@export var reload_time: float = 3.0    # reload delay in seconds
var bullets_left: int                   # how many bullets are currently in mag
var right_click_was_pressed = false

func _ready() -> void:
	bullets_left = mag_size   # start with a full magazine



func _process(delta: float) -> void:
	# Make the gun aim at the mouse
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

	# Flip sprite vertically if aiming left
	if mouse_pos.x < global_position.x:
		gun_sprite.flip_v = true
	else:
		gun_sprite.flip_v = false

	# Handle shooting input
	if Input.is_action_pressed("shoot") and not shooting:
		shooting = true
		start_shooting()
	elif not Input.is_action_pressed("shoot") and shooting:
		shooting = false
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if not right_click_was_pressed:
			right_click_was_pressed = true
			reload()
			await get_tree().create_timer(reload_time).timeout
			print("Reloading...")
	else:
		right_click_was_pressed = false


func start_shooting() -> void:
	# Shooting loop
	await get_tree().process_frame
	while shooting:
		if can_shoot and bullet_scene and gun_muzzle:
			if bullets_left > 0:
				shoot()
				can_shoot = false
				await get_tree().create_timer(fire_rate).timeout
				can_shoot = true
			else:
				await reload()
		await get_tree().process_frame


func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	# Spawn bullet exactly at muzzle position
	bullet.global_position = gun_muzzle.global_position
	bullet.rota = gun_muzzle.global_rotation

	# Direction based on muzzle rotation (recommended)
	var dir = Vector2.RIGHT.rotated(gun_muzzle.global_rotation)
	bullet.dir = dir

	# Optional offset (adjust if needed)
	# bullet.global_position += dir * 8.0

	bullets_left -= 1
	print("Fired! Bullets left: ", bullets_left)


func reload() -> void:
	print("Reloading...")
	can_shoot = false
	await get_tree().create_timer(reload_time).timeout
	bullets_left = mag_size
	can_shoot = true
	print("Reload complete! Bullets reset to: ", bullets_left)
	
