class_name Arrow extends CharacterBody2D

@export var damage: float = 2.0
@export var distance: float = 350.0
@export var fly_time: float = 0.8
@export var gravity: float = 1000
## 箭矢偏移角度最小值
@export var random_angle_min: float = -0.2
## 箭矢偏移角度最大值
@export var random_angle_max: float = 0.2
## 中箭音效
@export var arrow_hit_sfx: Array[AudioSFXFXRequest]
## rage状态下中箭音效
@export var arrow_rage_sfx: Array[AudioSFXFXRequest]

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var collision_shape_2d: CollisionShape2D = $HitBox/CollisionShape2D
@onready var timer: Timer = $Timer
var archer: TinyDefenceArcher


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	archer = get_parent()
	hit_box.damage = damage
	velocity = Vector2(distance / fly_time, -0.5 * gravity * fly_time).rotated(randf_range(random_angle_min, random_angle_max))
	rotation = velocity.angle()
	
	hit_box.hit.connect(on_hit_box_hit)
	timer.timeout.connect(on_timer_timeout)


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	rotation = velocity.angle()
	var collide:KinematicCollision2D = move_and_collide(velocity * delta)
	if collide:
		on_collision()


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
	if archer.current_archer_state == TinyDefenceArcher.ArcherState.Rage:
		AudioMasterAutoload.PlaySFX(arrow_rage_sfx.pick_random())
	else:
		AudioMasterAutoload.PlaySFX(arrow_hit_sfx.pick_random())
	collision_shape_2d.set_deferred("disabled", true)


func on_timer_timeout() -> void:
	on_collision()
