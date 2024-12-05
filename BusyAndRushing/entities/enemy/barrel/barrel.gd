class_name Barrel extends EnemyBase

## 移动速度
@export var movement_speed: float = 100.0
## 最大血量
@export var max_hp: float = 1.0
## 朝向
@export var animated_sprite_2d_flip_h: bool = false
## 每个炸药桶得分
@export var score_per_barrel: int = 2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var juicy_bar: JucyBar = $JuicyBar
@onready var state_chart: StateChart = $StateChart
@onready var marker_2d: Marker2D = $Marker2D

var current_hp: float = 0.0


func _ready() -> void:
	current_hp = max_hp
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h


func _physics_process(delta: float) -> void:
	move_and_slide()


func get_score() -> void:
	var is_critical: bool = false
	DamageNumber.display_number(score_per_barrel, marker_2d.global_position, is_critical, "+")
	juicy_bar.decrease_current_value(1.0)


func explode() -> void:
	state_chart.send_event("walk_to_explode")


func _on_idle_state_entered() -> void:
	velocity = Vector2.ZERO
	state_chart.send_event("idle_to_walk")


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")


func _on_walk_state_entered() -> void:
	pass # Replace with function body.


func _on_walk_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("walk")
	var direction: Vector2 = Vector2.RIGHT
	if animated_sprite_2d.flip_h:
		direction = Vector2.LEFT
	velocity = direction * movement_speed


func _on_explode_state_entered() -> void:
	velocity = Vector2.ZERO
	animated_sprite_2d.play("explode")
	state_chart.send_event("explode_to_die")


func _on_die_state_entered() -> void:
	animated_sprite_2d.play("explosion")
	await animated_sprite_2d.animation_finished
	queue_free()
