extends Node

## 攻击武器
@export var axe_ability_scene: PackedScene

var base_damage: float = 10.0


func add_axe() -> void:
	var enemy:CharacterBody2D = get_tree().get_first_node_in_group("enemy") as CharacterBody2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	var axe_instance: Node2D = axe_ability_scene.instantiate() as Node2D
	if !is_instance_valid(enemy) or !is_instance_valid(axe_instance) or !is_instance_valid(foreground_layer):
		return

	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = owner.global_position
	axe_instance.scale = owner.scale/2
	#TODO 伤害待优化
	axe_instance.hitbox_component.damage = base_damage
	axe_instance.target_pos = enemy.global_position
