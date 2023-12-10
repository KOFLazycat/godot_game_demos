extends Node
## 攻击武器
@export var bullet_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var base_damage: float = 10.0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	##TODO 测试
	timer.autostart = true
	timer.start()


func on_timer_timeout() -> void:
	var bullet_instance: Node2D = bullet_ability_scene.instantiate() as Node2D
	if !is_instance_valid(bullet_instance):
		return
	
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if !is_instance_valid(foreground_layer):
		return
	foreground_layer.add_child(bullet_instance)
	bullet_instance.global_position = owner.global_position
	#TODO 伤害待优化
	bullet_instance.hitbox_component.damage = base_damage
