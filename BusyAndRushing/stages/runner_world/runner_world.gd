extends Node2D

@export var ground_velocity_x: float = 150.0
## 初始金币数量
@export var init_gold_num: int = 100

@onready var ground_parallax_layer: ParallaxLayer = $ParallaxBackground/GroundParallaxLayer
@onready var cloud_parallax_layer: ParallaxLayer = $ParallaxBackground/CloudParallaxLayer
@onready var jump_button: Button = $JumpButton
@onready var runner_player: RunnerPlayer = $RunnerPlayer
@onready var rock_group: Node2D = $RockGroup
@onready var rock_spawn_timer: Timer = $RockSpawnTimer
@onready var hurt_box: HurtBox = $HurtBox
@onready var label: Label = $Ui/PanelContainer/HBoxContainer/Label
var runner_rock_tscn: PackedScene = preload("res://entities/enemy/runner_rock/runner_rock.tscn")

var current_gold_num: int = 0

func _ready() -> void:
	LabelUtil.set_label(label)
	current_gold_num = LoadSaveSystem.load_gold_num()
	current_gold_num = clampi(current_gold_num, init_gold_num, current_gold_num)
	LabelUtil.set_label_text(0, current_gold_num, 0.5)
	rock_spawn_timer.wait_time = randf_range(5.0, 10.0)
	jump_button.pressed.connect(on_jump_button_pressed)
	rock_spawn_timer.timeout.connect(on_rock_spawn_timer_timeout)
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _physics_process(delta: float) -> void:
	cloud_parallax_layer.motion_offset.x -= delta * ground_velocity_x / 10
	ground_parallax_layer.motion_offset.x -= delta * ground_velocity_x


func on_jump_button_pressed() -> void:
	runner_player.jump()
	current_gold_num += runner_player.obtain_gold_num
	LabelUtil.set_label_text(current_gold_num - runner_player.obtain_gold_num, current_gold_num, 0.5)
	LoadSaveSystem.save_gold_num(current_gold_num)


func on_rock_spawn_timer_timeout() -> void:
	var rock_pos_x: float = 1400.0 + randf_range(50, 300)
	var runner_rock: RunnerRock = runner_rock_tscn.instantiate()
	runner_rock.global_position = Vector2(rock_pos_x, 215.0)
	runner_rock.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
	add_child(runner_rock)
	rock_spawn_timer.wait_time = randf_range(5.0, 10.0)


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hit_box.owner.queue_free()
