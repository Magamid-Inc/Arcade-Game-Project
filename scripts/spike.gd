extends Area2D

@export var damage: int = 10
@export var destroy_on_hit: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

		if destroy_on_hit:
			queue_free()
