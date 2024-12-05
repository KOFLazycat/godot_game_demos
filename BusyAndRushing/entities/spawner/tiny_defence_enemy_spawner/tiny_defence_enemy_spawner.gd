class_name TinyDefenceEnemySpawner extends Node2D

## 生成间隔时间
@export var spawn_interval: float = 10.0

@onready var timer: Timer = $Timer
@onready var tiny_defence_tnt_tscn: PackedScene = preload("res://entities/enemy/tiny_defence_tnt/tiny_defence_tnt.tscn") as PackedScene
@onready var enemy_group: Node = get_tree().get_first_node_in_group("enemies")


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	# 生成第一个敌人
	enemy_spawn()

# 生产敌人
func enemy_spawn() -> void:
	var tiny_defence_tnt: CharacterBody2D = tiny_defence_tnt_tscn.instantiate() as CharacterBody2D
	tiny_defence_tnt.animated_sprite_2d_flip_h = true
	tiny_defence_tnt.global_position = Vector2(randf_range(1200, 1250), randf_range(540, 650))
	enemy_group.add_child(tiny_defence_tnt)


func on_timer_timeout() -> void:
	enemy_spawn()
