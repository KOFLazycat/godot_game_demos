class_name TinyDefenceTnt extends EnemyBase
## 移动速度
@export var movement_speed: float = 20.0
## 最大血量
@export var max_hp: float = 10.0
## 
@export var knockback_recovery: float = 3.5
## 攻击间隔
#@export var attack_interval: float = 2.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var castle = get_tree().get_first_node_in_group("castle")
@onready var hurt_box: HurtBox = $HurtBox
@onready var juicy_bar: JucyBar = $JuicyBar
@onready var state_chart: StateChart = $StateChart
@onready var idle_to_attack: Transition = $StateChart/Root/Idle/ToAttack
@onready var dynamite_tscn: PackedScene = preload("res://entities/bullet/dynamite/dynamite.tscn") as PackedScene
@onready var marker_2d_right: Marker2D = $AnimatedSprite2D/Marker2DRight
@onready var marker_2d_left: Marker2D = $AnimatedSprite2D/Marker2DLeft

var knockback: Vector2 = Vector2.ZERO
var dead: bool = false
var hp: float = 0.0
var animated_sprite_2d_flip_h: bool = false
const STOP_DISTANCE: float = 300.0


func _ready() -> void:
	hp = max_hp
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h
	#idle_to_attack.delay_seconds = attack_interval
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _physics_process(delta: float) -> void:
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
	hp = clampf(hp - damage, 0.0, max_hp)
	var decrease_percent: float = damage / max_hp
	juicy_bar.decrease_current_value(decrease_percent)
	if hp == 0.0:
		dead = true
		velocity = Vector2.ZERO
		animated_sprite_2d.play("die")
		await animated_sprite_2d.animation_finished
		queue_free()


# 进入idle状态
func _on_idle_state_entered() -> void:
	velocity = Vector2.ZERO
	#if global_position.distance_to(castle.global_position) > STOP_DISTANCE:
		#state_chart.send_event("idle_to_walk")
	#else:
		#state_chart.send_event("idle_to_attack")


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")
	if global_position.distance_to(castle.global_position) > STOP_DISTANCE:
		state_chart.send_event("idle_to_walk")
	else:
		state_chart.send_event("idle_to_attack")


# 进入walk状态
func _on_walk_state_entered() -> void:
	pass


# 在walk状态下处理逻辑
func _on_walk_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("walk")
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction: Vector2 = global_position.direction_to(castle.global_position)
	velocity = direction * movement_speed
	velocity += knockback
	if global_position.distance_to(castle.global_position) <= STOP_DISTANCE:
		state_chart.send_event("walk_to_idle")


# 进入攻击状态
func _on_attack_state_entered() -> void:
	velocity = Vector2.ZERO
	fire()
