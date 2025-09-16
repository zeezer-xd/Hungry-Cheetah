extends CharacterBody2D

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var col_shape: CollisionShape2D = $CollisionShape2D

var speed: float = 100.0
var target: Node2D = null
var hp: int = 60   # Enemy starts with 60 HP

func _ready() -> void:
	# Find player (make sure player is in "player" group)
	target = get_tree().get_first_node_in_group("player")
	if target:
		agent.target_position = target.global_position

	# Connect collision signals if they exist on this node.
	# Some collision objects expose "body_entered", others "area_entered" — we handle both.
	if has_signal("body_entered"):
		connect("body_entered", Callable(self, "_on_body_entered"))
	if has_signal("area_entered"):
		connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta: float) -> void:
	if not target:
		return

	# Update path toward player
	agent.target_position = target.global_position
	var next_point: Vector2 = agent.get_next_path_position()

	if next_point != Vector2.ZERO:
		var direction: Vector2 = (next_point - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Play walk animation if moving
		if direction.length() > 0.1:
			sprite.play("walk")
		else:
			sprite.stop()
	else:
		# no path / close enough
		velocity = Vector2.ZERO
		move_and_slide()

# Signals call this when something hits the enemy
func _on_body_entered(body: Node) -> void:
	_handle_hit(body)

func _on_area_entered(area: Node) -> void:
	_handle_hit(area)

func _handle_hit(collider: Node) -> void:
	if collider == null:
		return
	# bullets must be added to the "bullet" group
	if collider.is_in_group("bullet"):
		take_damage(20)
		# try to free the bullet if it still exists
		if collider.is_inside_tree():
			collider.queue_free()

func take_damage(amount: int) -> void:
	hp -= amount
	print("Enemy HP:", hp)   # debug
	if hp <= 0:
		# optional: play death animation, spawn particles, etc. before freeing
		queue_free()
