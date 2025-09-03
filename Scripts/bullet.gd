extends Area2D

@export var speed: float = 600
@export var lifetime: float = 2.0
@export var damage: int = 20   # set default damage

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# When bullet collides
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)   # <-- use exported damage
	$CollisionShape2D.disabled = true
	queue_free()
