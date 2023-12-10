extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)


func on_body_entered(boddy: Node2D) -> void:
	if boddy.is_in_group("player") and is_instance_valid(boddy.axe_ability_controller):
		boddy.axe_ability_controller.call_deferred("add_axe")
