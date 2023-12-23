extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(boddy: Node2D) -> void:
	if boddy.is_in_group("player"):
		Global.change_scene("main_menu")
