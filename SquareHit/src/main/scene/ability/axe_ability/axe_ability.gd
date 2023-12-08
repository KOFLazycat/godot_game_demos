extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent


var enemy_pos: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if enemy_pos != Vector2.ZERO:
		global_position = global_position.move_toward(enemy_pos, delta * 200)

