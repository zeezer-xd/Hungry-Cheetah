extends Area2D

@export var speed: float = 600
@export var lifetime: float = 2.0
@export var damage: int = 20   # set default damage
var pos: Vector2
var rota: float
var dir: Vector2 = Vector2.ZERO  # Default to zero vector

func _ready() -> void:
	global_position = pos
	global_rotation = rota
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if dir != Vector2.ZERO:
		var velocity = dir.normalized() * speed
		position += velocity * delta

# When bullet collides
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage)   # <-- use exported damage
	$CollisionShape2D.disabled = true
	queue_free()
