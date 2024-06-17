extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var player_base: PlayerBase = $PlayerBase
@onready var enemy_base_scene: PackedScene = preload("res://src/main/scene/role/enemy/enemy_base/enemy_base.tscn")

const MAX_ENEMY_COUNT: int = 20
var total_enemy_num: int = 0

func _ready() -> void:
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)


func _on_enemy_spawn_timer_timeout() -> void:
	for i in range(10):
		var enemy_base: EnemyBase = enemy_base_scene.instantiate()
		enemy_base.global_position = Vector2(450, 450)
		enemy_base.player = player_base
		add_child(enemy_base)
		total_enemy_num += 1
		if total_enemy_num >= MAX_ENEMY_COUNT:
			enemy_spawn_timer.stop()
			break
	
