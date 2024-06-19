extends Node2D
class_name EnemySpawnFlash # Enemy出生点闪烁

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal spawn_enemy(pos: Vector2)

func _ready() -> void:
	animation_player.play("flash")
	await animation_player.animation_finished
	spawn_enemy.emit(global_position)
	queue_free()
