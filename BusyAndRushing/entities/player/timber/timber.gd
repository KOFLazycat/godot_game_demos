class_name Timber extends PlayerBase

## 每次砍伐能获取的分数
@export var score_per_chop: int = 1
## 砍伐音效
@export var chop_sfx: Array[AudioSFXFXRequest]

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_chart: StateChart = $StateChart
@onready var hit_box: HitBox = $HitBox
@onready var marker_2d: Marker2D = $Marker2D


func _ready() -> void:
	hit_box.damage = score_per_chop

# 砍树
func choping() -> void:
	state_chart.send_event("idle_to_chop")


func _on_idle_state_physics_processing(delta: float) -> void:
	animation_player.play("idle")


func _on_chop_state_entered() -> void:
	animation_player.play("chop")
	AudioMasterAutoload.PlaySFX(chop_sfx.pick_random())
	await animation_player.animation_finished
	var is_critical: bool = false
	DamageNumber.display_number(score_per_chop, marker_2d.global_position, is_critical, "+")
	GameManager.add_game_score(score_per_chop)
	state_chart.send_event("chop_to_idle")
