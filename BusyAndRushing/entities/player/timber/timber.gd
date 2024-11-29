class_name Timber extends PlayerBase

## 每次砍伐能获取树木的数量
@export var obtain_wood_num: int = 10

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_chart: StateChart = $StateChart
@onready var hit_box: HitBox = $HitBox
@onready var marker_2d: Marker2D = $Marker2D


func _ready() -> void:
	hit_box.damage = obtain_wood_num

# 砍树
func choping() -> void:
	state_chart.send_event("idle_to_chop")


func _on_idle_state_physics_processing(delta: float) -> void:
	animation_player.play("idle")


func _on_chop_state_entered() -> void:
	animation_player.play("chop")
	await animation_player.animation_finished
	var is_critical: bool = false
	DamageNumber.display_number(obtain_wood_num, marker_2d.global_position, is_critical, "+")
	state_chart.send_event("chop_to_idle")
