extends Area2D

@export var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Delete the bullet after 2 seconds automatically
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta: float) -> void:
	# Move the bullet
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# For now just remove the bullet when it hits anything
	queue_free()
