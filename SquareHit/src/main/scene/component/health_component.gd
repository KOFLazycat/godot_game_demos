class_name HealthComponent
extends Node2D

## 最大血量
@export var max_health: float = 100

@onready var health_bar_bottom: TextureProgressBar = $Control/HealthBarBottom
@onready var health_bar_top: TextureProgressBar = $Control/HealthBarTop

# 当前血量
var current_health: float
# 血量变化tween变化时间
var change_time = 0.1
# 血量变化底部缓冲tween变化时间
var change_buffer = 0.5
# 死亡信号
signal died
# 血量变化信号
signal health_changed
# 血量增加信号
signal health_incresed
# 血量减少信号
signal health_decresed

func _ready() -> void:
	current_health = max_health
	
	# 血条是百分数
	health_bar_bottom.value = 1
	health_bar_top.value = 1


# 受伤函数，传递值为负数时表示增加血量，正数时表示减少血量
func damage(damage_amount: float) -> void:
	if damage_amount == 0:
		return
	# 是否是扣血
	var is_decresed: bool = true
	if damage_amount > 0 and current_health > 0:
		is_decresed = true
		health_decresed.emit()
	if damage_amount < 0 and current_health < max_health:
		is_decresed = false
		health_incresed.emit()
	
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	
	# 血条缓慢退下
	var tween = create_tween()
	var bar_value: float = get_health_percent()
	if is_decresed:
		tween.tween_property(health_bar_top, "value", bar_value, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(health_bar_bottom, "value", bar_value, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(health_bar_bottom, "value", bar_value, change_time).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(health_bar_top, "value", bar_value, change_buffer).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(check_death)


# 治疗函数
func heal(heal_amount: float) -> void:
	damage(-1 * heal_amount)


func get_health_percent() -> float:
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()


func _on_timer_timeout() -> void:
	damage(10)
