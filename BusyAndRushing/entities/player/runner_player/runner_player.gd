class_name RunnerPlayer extends PlayerBase

@export var jump_velocity_y: float = 500.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: HurtBox = $HurtBox
@onready var state_chart: StateChart = $StateChart

var default_gravity: float = 800.0
var is_jumping: bool = false

signal runner_player_die

func _ready() -> void:
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _physics_process(delta: float) -> void:
	velocity.y += default_gravity * delta
	move_and_slide()


# 跳跃
func jump() -> void:
	if !is_jumping:
		velocity.y = jump_velocity_y * (-1)
		state_chart.send_event("idle_to_jump")


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hit_box.owner.explode()
	state_chart.send_event("to_die")


func _on_idle_state_entered() -> void:
	is_jumping = false


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")


func _on_jump_state_entered() -> void:
	is_jumping = true


func _on_jump_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("jump")
	if is_on_floor():
		state_chart.send_event("jump_to_idle")


func _on_die_state_entered() -> void:
	is_jumping = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("hurt")
	await animated_sprite_2d.animation_finished
	runner_player_die.emit()
