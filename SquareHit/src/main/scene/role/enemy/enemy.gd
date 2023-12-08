extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	health_component.died.connect(on_died)
	hurtbox_component.hit.connect(on_hit)
	animation_player.animation_finished.connect(on_animation_finished)


func on_died() -> void:
	animation_player.play("die")


func on_hit() -> void:
	pass


func on_animation_finished(_anim_name: StringName) -> void:
	queue_free()
