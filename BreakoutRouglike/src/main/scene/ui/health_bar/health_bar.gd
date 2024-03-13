extends Control

@export var health_empty: CompressedTexture2D = preload("res://src/main/assets/textures/health/HeartEmpty.png")
@export var health_full: CompressedTexture2D = preload("res://src/main/assets/textures/health/HeartFull.png")

var health: int = 3
@onready var hb: HBoxContainer = $HB


func set_health(new_health: int) -> void:
	health = new_health
	for i in range(hb.get_child_count()):
		if i < health:
			hb.get_child(i).texture = health_full
		else:
			hb.get_child(i).texture = health_empty
