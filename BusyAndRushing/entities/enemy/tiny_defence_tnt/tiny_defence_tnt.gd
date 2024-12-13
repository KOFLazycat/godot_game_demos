class_name TinyDefenceTnt extends EnemyBase
## 移动速度
@export var movement_speed: float = 20.0
## 最大血量
@export var max_hp: float = 10.0
## 
@export var knockback_recovery: float = 3.5
## 攻击间隔
#@export var attack_interval: float = 2.0
## 每个敌人死亡得分
@export var score_per_tnt: int = 10


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var tower = get_tree().get_first_node_in_group("tower")
@onready var hurt_box: HurtBox = $HurtBox
@onready var juicy_bar: JucyBar = $JuicyBar
@onready var state_chart: StateChart = $StateChart
@onready var idle_to_attack: Transition = $StateChart/Root/Idle/ToAttack
@onready var dynamite_tscn: PackedScene = preload("res://entities/bullet/dynamite/dynamite.tscn") as PackedScene
@onready var marker_2d_right: Marker2D = $AnimatedSprite2D/Marker2DRight
@onready var marker_2d_left: Marker2D = $AnimatedSprite2D/Marker2DLeft
@onready var marker_2d: Marker2D = $AnimatedSprite2D/Marker2D
@onready var marker_2d_2: Marker2D = $AnimatedSprite2D/Marker2D2

var knockback: Vector2 = Vector2.ZERO
var current_hp: float = 0.0
var animated_sprite_2d_flip_h: bool = false
const STOP_DISTANCE: float = 400.0


func _ready() -> void:
	current_hp = max_hp
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h
	#idle_to_attack.delay_seconds = attack_interval
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _physics_process(delta: float) -> void:
	if current_hp <= 0:
		state_chart.send_event("to_die")
	move_and_slide()


func fire() -> void:
	animated_sprite_2d.play("drop_bomb")
	await animated_sprite_2d.animation_finished
	state_chart.send_event("attack_to_idle")
	var dynamite: Dynamite = dynamite_tscn.instantiate() as Dynamite
	if animated_sprite_2d.flip_h:
		dynamite.position = marker_2d_left.position
		dynamite.distance = dynamite.distance * (-1)
	else:
		dynamite.position = marker_2d_right.position
	add_child(dynamite)
	animated_sprite_2d.play("take_bomb")
	await animated_sprite_2d.animation_finished


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	current_hp = clampf(current_hp - damage, 0.0, max_hp)
	var decrease_percent: float = damage / max_hp
	juicy_bar.decrease_current_value(decrease_percent)
	var is_critical: bool = true
	DamageNumber.display_number(int(damage), marker_2d_2.global_position, is_critical, "-")


# 进入idle状态
func _on_idle_state_entered() -> void:
	velocity = Vector2.ZERO


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")
	if global_position.distance_to(tower.global_position) > STOP_DISTANCE:
		state_chart.send_event("idle_to_walk")
	else:
		state_chart.send_event("idle_to_attack")


# 在walk状态下处理逻辑
func _on_walk_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("walk")
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction: Vector2 = global_position.direction_to(tower.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	if global_position.distance_to(tower.global_position) <= STOP_DISTANCE:
		state_chart.send_event("walk_to_idle")


# 进入攻击状态
func _on_attack_state_entered() -> void:
	velocity = Vector2.ZERO
	fire()


func _on_die_state_entered() -> void:
	velocity = Vector2.ZERO
	animated_sprite_2d.material.set_shader_parameter("width", 0.0)
	animated_sprite_2d.play("die")
	var is_critical: bool = false
	DamageNumber.display_number(score_per_tnt, marker_2d.global_position, is_critical, "+")
	GameManager.add_game_score(score_per_tnt)
	await animated_sprite_2d.animation_finished
	queue_free()
