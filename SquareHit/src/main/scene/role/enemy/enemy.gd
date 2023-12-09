extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	health_component.died.connect(on_health_component_died)
	hurtbox_component.hit.connect(on_hurtbox_component_hit)
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


func attack() -> void:
	pass
	#var enemy:CharacterBody2D = get_tree().get_first_node_in_group("enemy") as CharacterBody2D
	#var axe_instance: Node2D = axe_ability_scene.instantiate() as Node2D
	#if !is_instance_valid(enemy) or !is_instance_valid(axe_instance):
		#return
	#var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	#if !is_instance_valid(foreground_layer):
		#return
	#foreground_layer.add_child(axe_instance)
	#axe_instance.global_position = global_position
	##TODO 伤害待优化
	#axe_instance.hitbox_component.damage = 10
	#axe_instance.target_pos = enemy.global_position


func on_health_component_died() -> void:
	animation_player.play("die")


func on_hurtbox_component_hit() -> void:
	pass


func on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
