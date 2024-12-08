class_name TinyDefenceWorld extends Node2D

@onready var tower: Tower = $Tower
@onready var tiny_defence_enemy_spawner_tscn: PackedScene = preload("res://entities/spawner/tiny_defence_enemy_spawner/tiny_defence_enemy_spawner.tscn") as PackedScene

signal tiny_defence_world_game_over


func _ready() -> void:
	tower.tower_die.connect(on_tower_tower_die)


func game_world_start() -> void:
	var tiny_defence_enemy_spawner: TinyDefenceEnemySpawner = tiny_defence_enemy_spawner_tscn.instantiate()
	add_child(tiny_defence_enemy_spawner)


func on_tower_tower_die() -> void:
	tiny_defence_world_game_over.emit()
