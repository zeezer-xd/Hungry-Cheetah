extends Camera2D

@export var smoothing = 8.0
@export var camera_offset = Vector2.ZERO
@export var player_path: NodePath

var pplayer

func _ready():
	if player_path != NodePath(""):
		pplayer = get_node(player_path)
	position_smoothing_enabled = false

func _physics_process(delta):
	if not pplayer:
		return

	var target_pos = pplayer.global_position + camera_offset
	var factor = clamp(1.0 - exp(-smoothing * delta), 0.0, 1.0)

	global_position = global_position.lerp(target_pos, factor)
