extends CharacterBody2D

@onready var agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D

var speed: float = 100.0
var target: Node2D = null

func _ready():
	# Find the player (make sure player is in group "player")
	target = get_tree().get_first_node_in_group("player")

	if target:
		agent.target_position = target.global_position

func _physics_process(delta):
	if not target:
		return

	# Continuously update target position (so it chases the moving player)
	agent.target_position = target.global_position

	# Ask the agent for the next point along the path
	var next_point = agent.get_next_path_position()

	if next_point != Vector2.ZERO:
		var direction = (next_point - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Play animation if moving
		if direction.length() > 0.1:
			sprite.play("walk")
		else:
			sprite.stop()
