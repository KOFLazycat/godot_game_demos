extends Area2D
class_name HitSystem # 攻击系统，造成伤害

#@export_group("Damage")
## 每次攻击造成的伤害最小数值
@export var min_damage: float = 1.0
## 每次攻击造成的伤害最大数值
@export var max_damage: float = 10.0
## 伤害类型
@export var hit_type: HitType

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableTimer

# 击退距离
var knockback_amount: float = 100.0
# 攻击角度
var angle: Vector2 = Vector2.ZERO

enum HitType {NORMAL, FIRE, POISON}
signal remove_from_hit_once_array(obj: Area2D)


func _ready() -> void:
	disable_timer.timeout.connect(_on_disable_timer_timeout)
 

# 获取实际伤害值
func get_damage() -> float:
	return randf_range(min_damage, max_damage)


# hit进入cd
# t: 冷却时间，0表示无冷却
func disable_hit(t: float) -> void:
	if t == 0.0:
		return
	collision_shape_2d.call_deferred("set", "disabled", true)
	if disable_timer.is_stopped():
		disable_timer.wait_time = t
		disable_timer.start()

# 攻击动作
func hit():
	pass


func _on_disable_timer_timeout() -> void:
	collision_shape_2d.disabled = false
