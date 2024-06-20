extends Control
class_name HealthBar ## 血条UI

## 血量变化tween变化时间
@export var change_time: float = 0.1 
## 血量变化底部缓冲tween变化时间
@export var change_buffer: float = 0.5 

@onready var bottom_texture_progress_bar: TextureProgressBar = $BottomTextureProgressBar
@onready var top_texture_progress_bar: TextureProgressBar = $TopTextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	bottom_texture_progress_bar.min_value = 0
	bottom_texture_progress_bar.max_value = 1
	bottom_texture_progress_bar.value = 1
	
	top_texture_progress_bar.min_value = 0
	top_texture_progress_bar.max_value = 1
	top_texture_progress_bar.value = 1


func update_value(v: float) -> void:
	var is_heal: bool = false # 是否是治疗
	var current_v: float = top_texture_progress_bar.value
	if current_v == v:
		return
	if current_v < v:
		is_heal = true
	
	var tween = create_tween()
	if is_heal:
		# 治愈
		tween.tween_property(bottom_texture_progress_bar, "value", v, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(top_texture_progress_bar, "value", v, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	else:
		# 扣血
		tween.tween_property(top_texture_progress_bar, "value", v, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(bottom_texture_progress_bar, "value", v, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
