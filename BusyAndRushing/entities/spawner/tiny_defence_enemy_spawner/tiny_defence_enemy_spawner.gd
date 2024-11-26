class_name TinyDefenceEnemySpawner extends Node2D

## 在左边还是右边
enum SpawnSide {LEFT, RIGHT, BOTH}
@export var spawn_side: SpawnSide = SpawnSide.LEFT
## 生成间隔时间
@export var spawn_interval: float = 10.0
## 左侧出生点
@export var spawn_left_position: Vector2 = Vector2.ZERO
## 右侧出生点
@export var spawn_right_position: Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer
@onready var tiny_defence_tnt_tscn: PackedScene = preload("res://entities/enemy/tiny_defence_tnt/tiny_defence_tnt.tscn") as PackedScene
@onready var enemy_group: Node = get_tree().get_first_node_in_group("enemies")
#@onready var enemy_left: Node = get_tree().get_first_node_in_group("enemy_left")
#@onready var enemy_right: Node = get_tree().get_first_node_in_group("enemy_right")


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	# 生成第一个敌人
	enemy_spawn()

# 生产敌人
func enemy_spawn() -> void:
	match spawn_side:
		SpawnSide.LEFT:
			spawn_one(spawn_side)
		SpawnSide.RIGHT:
			spawn_one(spawn_side)
		SpawnSide.BOTH:
			spawn_one(SpawnSide.LEFT)
			spawn_one(SpawnSide.RIGHT)


# 指定位置生产一个敌人
func spawn_one(side: SpawnSide) -> void:
	var tiny_defence_tnt: CharacterBody2D = tiny_defence_tnt_tscn.instantiate() as CharacterBody2D
	tiny_defence_tnt.scale = Vector2(0.5, 0.5)
	if side == SpawnSide.LEFT:
		tiny_defence_tnt.animated_sprite_2d_flip_h = false
		tiny_defence_tnt.global_position = spawn_left_position + Vector2(randf_range(-20, 20), randf_range(-15, 15))
	if side == SpawnSide.RIGHT:
		tiny_defence_tnt.animated_sprite_2d_flip_h = true
		tiny_defence_tnt.global_position = spawn_right_position + Vector2(randf_range(-20, 20), randf_range(-15, 15))
	enemy_group.add_child(tiny_defence_tnt)


func on_timer_timeout() -> void:
	enemy_spawn()
