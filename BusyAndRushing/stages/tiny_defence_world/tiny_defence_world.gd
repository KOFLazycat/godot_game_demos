class_name TinyDefenceWorld extends Node2D

@onready var tower: Tower = $Tower

signal tiny_defence_world_game_over


func _ready() -> void:
	tower.tower_die.connect(on_tower_tower_die)


func on_tower_tower_die() -> void:
	tiny_defence_world_game_over.emit()
