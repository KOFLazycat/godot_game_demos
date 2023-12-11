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


func on_health_component_died() -> void:
	animation_player.play("die")


func on_hurtbox_component_hit() -> void:
	pass


func on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()

