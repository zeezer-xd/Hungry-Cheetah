extends Node2D

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position
	if mouse_pos.x > player_pos.x:
		%gun_sprite.flip_v = false
	if mouse_pos.x < player_pos.x:
		%gun_sprite.flip_v = true
	look_at(get_global_mouse_position())
