extends Node2D


func _ready() -> void:
	Global.reset_game_state()
	get_tree().paused = false
	var child_scene: PackedScene = null
	child_scene = load(Global.level_map[Global.current_level])
	add_child( child_scene.instantiate() )

