extends Node
class_name HealthSystem

@export var min_health: float = 0.0
@export var max_health: float = 100.0

signal health_update(health: float, max_health: float)

var health: float:
	set(v):
		var old_health: float = health
		# 限制health范围
		health = clampf(v, 0, max_health)
		# 有在生命值发生变化是才会发射号
		if health != old_health:
			health_update.emit(health, max_health)


func _ready() -> void:
	# 等待一帧
	await get_tree().create_timer(0).timeout
	health = max_health


func get_health_percent() -> float:
	return remap(health, min_health, max_health, 0.0, 1.0)