extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var player_base: PlayerBase = $PlayerBase
@onready var enemy_spawn_flash_scene: PackedScene = preload("res://src/main/scene/role/enemy/enemy_spawn_flash/enemy_spawn_flash.tscn")
@onready var enemy_base_scene: PackedScene = preload("res://src/main/scene/role/enemy/enemy_base/enemy_base.tscn")
@onready var health_bar: HealthBar = $UI/HealthBar

const MAX_ENEMY_COUNT: int = 10
var total_enemy_num: int = 0

func _ready() -> void:
	AudioSystem.play_bgm(AudioSystem.BGM_INDEX.CEPHALOPOD)
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)


func _on_enemy_spawn_timer_timeout() -> void:
	if MAX_ENEMY_COUNT <= 0:
		return
		
	for i in range(10):
		var spawn_pos: Vector2 = Vector2(400+randf_range(-50, 50), 400+randf_range(-50, 50))
		var enemy_spawn_flash: Node2D = enemy_spawn_flash_scene.instantiate()
		enemy_spawn_flash.global_position = spawn_pos
		enemy_spawn_flash.spawn_enemy.connect(_on_enemy_spawn_flash_spawn_enemy)
		add_child(enemy_spawn_flash)
		
		total_enemy_num += 1
		if total_enemy_num >= MAX_ENEMY_COUNT:
			enemy_spawn_timer.stop()
			break


func _on_enemy_spawn_flash_spawn_enemy(pos: Vector2) -> void:
	var enemy_base:  = enemy_base_scene.instantiate()
	enemy_base.global_position = pos
	enemy_base.player = player_base
	add_child(enemy_base)
