extends Node2D

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var player_base: PlayerBase = $PlayerBase
@onready var enemy_spawn_flash_scene: PackedScene = preload("res://src/main/scene/role/enemy/enemy_spawn_flash/enemy_spawn_flash.tscn")
@onready var enemy_base_scene: PackedScene = preload("res://src/main/scene/role/enemy/enemy_base/enemy_base.tscn")
@onready var health_bar: HealthBar = $UI/HealthBar
@onready var green_flat_tile_map_layer: TileMapLayer = $Map/GreenFlatTileMapLayer

#const MAX_ENEMY_COUNT: int = 10
#var total_enemy_num: int = 0
# GreenFlat左上角格子
var green_left_top: Vector2i = Vector2i(4, 4)
# GreenFlat右下角格子
var green_right_bottom: Vector2i = Vector2i(25, 11)
var enemy_spawn_count: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


func _ready() -> void:
	AudioSystem.play_bgm(AudioSystem.BGM_INDEX.CEPHALOPOD)
	enemy_spawn_timer.wait_time = 5
	enemy_spawn_timer.start()
	enemy_spawn_timer.timeout.connect(_on_enemy_spawn_timer_timeout)


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy_num = enemy_spawn_count.pick_random()
	for i in range(enemy_num):
		var enemy_spawn_grid: Vector2i = Vector2i(randi_range(green_left_top.x, green_right_bottom.x), randi_range(green_left_top.y, green_right_bottom.y))
		var spawn_pos: Vector2 = green_flat_tile_map_layer.map_to_local(enemy_spawn_grid)
		var enemy_spawn_flash: Node2D = enemy_spawn_flash_scene.instantiate()
		enemy_spawn_flash.global_position = spawn_pos
		enemy_spawn_flash.spawn_enemy.connect(_on_enemy_spawn_flash_spawn_enemy)
		add_child(enemy_spawn_flash)
	
	enemy_spawn_timer.wait_time += 10


func _on_enemy_spawn_flash_spawn_enemy(pos: Vector2) -> void:
	var enemy_base:  = enemy_base_scene.instantiate()
	enemy_base.global_position = pos
	enemy_base.player = player_base
	add_child(enemy_base)
