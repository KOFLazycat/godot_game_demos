extends Node2D

@export var ghost_scene: PackedScene = preload("res://src/main/scene/role/paddle/ghost.tscn")
@export var sprite: Sprite2D
@export var color: Color

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func start_spawn() -> void:
	timer.start()


func stop_spawn() -> void:
	timer.stop()


func on_timer_timeout() -> void:
	var instance: Sprite2D = ghost_scene.instantiate()
	get_tree().get_current_scene().add_child(instance)
	instance.global_position = sprite.global_position
	instance.rotation = sprite.rotation
	instance.texture = sprite.texture
	instance.self_modulate = color
	instance.scale = sprite.scale
	instance.z_index = 0
