extends Area2D
class_name HurtSystem # 受击系统，受到伤害

## 受伤类型：
## COOLDOWN 受到伤害后，短时间内不会再次受到所有单位的伤害，类似于短时间内无敌；
## HURT_ONCE 受到特定单位的伤害后，短时间内不会再次受到该单位的伤害，但是会受到其他单位的伤害；
## DISABLE_HIT 受到特定单位的伤害后，短时间内会使该单位后续的伤害失效。
@export var hurt_type: HurtType
## 冷却时间，无敌时间
@export var cooldown_time: float = 1.0
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableTimer

var hit_once_array: Array[Area2D] = []
enum HurtType {COOLDOWN, HURT_ONCE, DISABLE_HIT}

signal hurt(damage: float, knockback_amount: float, angle: Vector2)


func _ready() -> void:
	disable_timer.wait_time = cooldown_time
	disable_timer.timeout.connect(_on_disable_timer_timeout)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


# 进入冷却时间
func cooldown() -> void:
	collision_shape_2d.call_deferred("set", "disabled", true)
	disable_timer.start()


# 处理hit once的情况，返回是否已经碰撞过了，如果过已经碰撞过了返回true，否则为false
func hit_once(area: Area2D) -> void:
	#if hit_once_array.has(area) == true:
		#return true
	if hit_once_array.has(area) == false:
		hit_once_array.append(area)
		# 链接移出信号
		if area.has_signal("remove_from_hit_once_array"):
			if not area.is_connected("remove_from_hit_once_array", Callable(self, "remove_from_hit_once_array")):
				area.connect("remove_from_hit_once_array", Callable(self, "remove_from_hit_once_array"))
	#return false

# 移除hit_once_array
func remove_from_hit_once_array(object: Area2D) -> void:
	if hit_once_array.has(object):
		hit_once_array.erase(object)


func disable_hit(area: Area2D) -> void:
	if area.has_method("disable_hit"):
		area.disable_hit()


# 处理hit
func deal_hit(area: Area2D) -> void:
	if area.has_method("get_damage") and area.get_damage():
		match hurt_type:
			HurtType.COOLDOWN: #COOLDOWN
				cooldown()
			HurtType.HURT_ONCE: #HURT_ONCE
				# TODO: 逻辑存在问题，待调整
				hit_once(area)
				#var is_already_hit: bool = hit_once(area)
				#print(is_already_hit)
				#if is_already_hit:
					## 如果已经碰撞了，直接返回，避免二次碰撞
					#return
			HurtType.DISABLE_HIT: #DISABLE_HIT
				disable_hit(area)
		
		var damage: float = area.get_damage()
		var angle: Vector2 = Vector2.ZERO
		if area.get("angle"):
			angle = area.angle
		
		var knockback_amount: float = 1.0
		if area.get("knockback_amount"):
			knockback_amount = area.knockback_amount
		
		if area.has_method("hit"):
			area.hit()
		# 发出受伤信号
		emit_signal("hurt", damage, knockback_amount, angle)


func _on_area_entered(area: Area2D) -> void:
	if area is HitSystem:
		deal_hit(area)


func _on_area_exited(area: Area2D) -> void:
	pass


func _on_disable_timer_timeout() -> void:
	collision_shape_2d.call_deferred("set","disabled",false)
