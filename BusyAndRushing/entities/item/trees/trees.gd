class_name Trees extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_chart: StateChart = $StateChart
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")


func _on_swing_state_entered() -> void:
	animated_sprite_2d.play("swing")
	await animated_sprite_2d.animation_finished
	state_chart.send_event("swing_to_idle")


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	state_chart.send_event("idle_to_swing")
