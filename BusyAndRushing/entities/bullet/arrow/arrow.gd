extends CharacterBody2D

@export var damage: float = 2.0
## 箭矢运动速度
@export var speed: float = 400.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
@onready var timer: Timer = $Timer

var arrow_hit_array: Array[HurtBox] = []
var target_enemy: EnemyBase
var last_enemy_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO # 箭矢指向的归一化向量
var current_time: float = 0.0
var next_point: Vector2 = Vector2.ZERO
var control_1_fix: float = 2.0
var attack_side: int = 0# 攻击方向左侧，1是右侧

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.damage = damage
	if attack_side == 0:
		direction = Vector2(1.2, 0.5).normalized()
		control_1_fix = 1.0
		rotate(-PI*3/4)
	else:
		direction = Vector2(1.8, 0.5).normalized()
		control_1_fix = 2.0
		rotate(-PI*1/4)
	hit_box.hit.connect(on_hit_box_hit)
	timer.timeout.connect(on_timer_timeout)


func _physics_process(delta: float) -> void:
	bezier_move(delta)
	var collide:KinematicCollision2D = move_and_collide(velocity * delta)
	if collide:
		on_collision()


## 通过贝塞尔曲线函数bezier_interpolate计算箭矢运动方向
func bezier_move(delta: float) -> void:
	if is_instance_valid(target_enemy):
		last_enemy_position = target_enemy.global_position
	
	set_next_point(delta, last_enemy_position)
	look_at(next_point)
	global_position = global_position.move_toward(next_point, speed * delta)


## 通过修正系数修正控制点1，通过起点和终点直线距离计算贝塞尔曲线时间参数，控制点2和终点相同，通过bezier_interpolate计算相应时间点的位置信息
func set_next_point(delta: float, target_pos: Vector2) -> void:
	current_time += delta
	var distance: float = global_position.distance_to(target_pos)
	# 两点之间，距离最短，时间也最短
	var min_time: float = distance / speed
	var t: float = min(current_time / min_time, 1)
	var start_control_point: Vector2 = direction * speed * control_1_fix
	next_point = global_position.bezier_interpolate(start_control_point, target_pos, target_pos, t)


func on_collision() -> void:
	set_physics_process(false)
	# 碰撞后不再检测伤害
	collision_shape_2d.set_deferred("disabled", true)
	var tween = create_tween()
	tween.tween_interval(randf_range(0.3, 0.7))
	tween.tween_property(self, "modulate:a", 0, 2.0)
	await  tween.finished
	queue_free()


func on_hit_box_hit(hurt_box: HurtBox) -> void:
	collision_shape_2d.set_deferred("disabled", true)


func on_timer_timeout() -> void:
	on_collision()
