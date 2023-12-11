extends Node

## 攻击武器
@export var restricted_zone_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage: float = 100.0


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	##TODO 测试
	timer.autostart = true
	timer.one_shot = true
	timer.start()


func on_timer_timeout() -> void:
	var enemy:CharacterBody2D = get_tree().get_first_node_in_group("enemy") as CharacterBody2D
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	var restricted_zone_instance: Node2D = restricted_zone_ability_scene.instantiate() as Node2D
	if !is_instance_valid(enemy) or !is_instance_valid(restricted_zone_instance) or !is_instance_valid(foreground_layer):
		return

	foreground_layer.add_child(restricted_zone_instance)
	restricted_zone_instance.global_position = owner.global_position
	#TODO 伤害待优化
	restricted_zone_instance.hitbox_component.damage = base_damage
	restricted_zone_instance.rotation = PI/2 *3
