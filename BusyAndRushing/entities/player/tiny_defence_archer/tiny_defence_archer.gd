class_name TinyDefenceArcher extends PlayerBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_tscn: PackedScene = preload("res://entities/bullet/arrow/arrow.tscn") as PackedScene
@onready var state_chart: StateChart = $StateChart

var animated_sprite_2d_flip_h: bool = false


func _ready() -> void:
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h


func fire() -> void:
	animated_sprite_2d.play("shot_tilt_up")
	await animated_sprite_2d.animation_finished
	var arrow: Arrow = arrow_tscn.instantiate()
	if animated_sprite_2d_flip_h:
		add_child(arrow)
	else:
		add_child(arrow)
	state_chart.send_event("attack_to_idle")


func _on_idle_state_entered() -> void:
	state_chart.send_event("idle_to_attack")


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")


func _on_attck_state_entered() -> void:
	fire()
