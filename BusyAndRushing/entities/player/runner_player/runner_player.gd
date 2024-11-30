class_name RunnerPlayer extends PlayerBase

@export var jump_velocity_y: float = 450.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hurt_box: HurtBox = $HurtBox
@onready var state_chart: StateChart = $StateChart
@onready var score_hurt_box: Area2D = $ScoreHurtBox

var default_gravity: float = ProjectSettings.get("physics/2d/default_gravity") as float
var obtain_gold_num: int = 10
var is_jumping: bool = false


func _ready() -> void:
	hurt_box.hurt.connect(on_hurt_box_hurt)
	score_hurt_box.area_entered.connect(on_score_hurt_box_area_entered)


func _physics_process(delta: float) -> void:
	velocity.y += default_gravity * delta
	move_and_slide()


# 跳跃
func jump() -> void:
	if !is_jumping:
		velocity.y = jump_velocity_y * (-1)
		state_chart.send_event("run_to_jump")


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	GameManager.set_game_over()


func on_score_hurt_box_area_entered(area: Area2D) -> void:
	obtain_gold_num = 0


func _on_run_state_entered() -> void:
	is_jumping = false


func _on_run_state_physics_processing(delta: float) -> void:
	animation_player.play("run")


func _on_jump_state_entered() -> void:
	is_jumping = true


func _on_jump_state_physics_processing(delta: float) -> void:
	animation_player.play("jump")
	if is_on_floor():
		state_chart.send_event("jump_to_run")
