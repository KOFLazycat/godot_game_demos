class_name BarrelSpawner extends Node2D

## 生成间隔时间
@export var spawn_interval: float = 10.0

@onready var timer: Timer = $Timer
@onready var barrel_tscn: PackedScene = preload("res://entities/enemy/barrel/barrel.tscn") as PackedScene
@onready var barrel_group: Node = get_tree().get_first_node_in_group("barrels")


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	# 生成第一个敌人
	enemy_spawn()

# 生产敌人
func enemy_spawn() -> void:
	var barrel: Barrel = barrel_tscn.instantiate()
	barrel.animated_sprite_2d_flip_h = true
	barrel.global_position = Vector2(1250, 210)
	barrel_group.add_child(barrel)


func on_timer_timeout() -> void:
	enemy_spawn()
