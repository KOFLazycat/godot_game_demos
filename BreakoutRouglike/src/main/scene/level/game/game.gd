class_name Game
extends Node2D

#@export var game_over_scene: PackedScene = preload("res://scenes/ui/game_over/game_over.tscn")
#@export var stage_clear_scene: PackedScene = preload("res://scenes/ui/stage_clear/stage_clear.tscn")
@export var brick_scene: PackedScene = preload("res://src/main/scene/role/brick/brick.tscn")
@export var block_energy: int = 10
@export var energy_block_energy: int = 100
@export var max_energy: int = 100

@onready var ball: Ball = $Ball
@onready var paddle: Paddle = $Paddle
@onready var energy_bar: Control = $CanvasLayer/EnergyBar
@onready var health_bar: Control = $CanvasLayer/HealthBar
@onready var score_ui: Control = $CanvasLayer/Score
@onready var combo_lbl: Label = $Comber
@onready var combo_timer: Timer = $ComboTimer
@onready var spawn_pos_container: Node = $SpawnPos
@onready var bricks_container: Node = $Bricks

var health: int = 3
var energy: float = 0.0
var score_brick_destroyed: int = 200
var score_brick_touched: int = 50
var score: int = 0
var combo: int = 0
var bricks: Array
var bricks_to_destroy: Array
var time: float = 0
var started: bool = false


func _ready() -> void:
	randomize()
	
	# 信号连接
	paddle.start.connect(on_paddle_start)
	combo_timer.timeout.connect(on_combo_timer_timeout)
	
	hide_combo()
	
	ball.attached_to = paddle.launch_point
	paddle.ball_attached = ball
	paddle.ball = ball
	
	for brick in get_tree().get_nodes_in_group("Bricks"):
		brick.energy_brick_destroyed.connect(on_energy_brick_destroyed)
		
	# Remove for testing with predefined bricks
	remove_all_bricks()
	layout_bricks()

######### Bricks ###########
# 移除所有brick
func remove_all_bricks() -> void:
	bricks.clear()
	bricks_to_destroy.clear()
	for brick in bricks_container.get_children():
		brick.queue_free()


func layout_bricks() -> void:
	var max_bricks: int = spawn_pos_container.get_child_count()
	for i in range(max_bricks):
		# 90% chance of having a block
		if randf() < 0.1: 
			continue
		add_brick(spawn_pos_container.get_child(i).global_position)


func add_brick(pos: Vector2) -> void:
	var brick_instance = brick_scene.instantiate()
	bricks_container.add_child(brick_instance)
	brick_instance.energy_brick_destroyed.connect(on_energy_brick_destroyed)
	brick_instance.destroyed.connect(on_brick_destroyed)
	brick_instance.global_position = pos
	bricks.append(brick_instance)
	if brick_instance.type != brick_instance.TYPE.EXPLOSIVE and brick_instance.type != brick_instance.TYPE.ENERGY:
		bricks_to_destroy.append(brick_instance)


func reset_and_attach_ball() -> void:
	ball.velocity = Vector2.ZERO
	ball.attached_to = paddle.launch_point
	paddle.ball_attached = ball
	paddle.game_over = false
	paddle.stage_clear = false


######### Energy ###########
# 增加能量
func add_energy(value: float) -> void:
	energy += value
	energy = clamp(energy, 0, max_energy)
	var v: float = energy / max_energy
	energy_bar.set_energy(v)


# 减少能量
func remove_energy(value: float) -> void:
	energy -= value
	energy = clamp(energy, 0, max_energy)
	var v: float = energy / max_energy
	energy_bar.set_energy(v)


# 重置能量
func reset_energy() -> void:
	energy = 0.0
	energy_bar.set_energy(energy)


######### Combo ###########
func show_combo(combo: int) -> void:
	combo_lbl.text = "COMBO " + str(combo)
	combo_lbl.visible = true


func hide_combo() -> void:
	combo_lbl.visible = false


######### SIGNALS ###########

func on_paddle_start() -> void:
	started = true


func on_energy_brick_destroyed() -> void:
	add_energy(energy_block_energy)


func on_brick_destroyed(which: Brick) -> void:
	bricks.erase(which)
	bricks_to_destroy.erase(which)
	
	combo += 1
	show_combo(combo)
	combo_timer.start()
	score += score_brick_destroyed * combo
	Globals.stats["score"] = score
	score_ui.set_score(score)
	
	if bricks_to_destroy.is_empty():
		started = false
		paddle.stage_clear = true
		Globals.stats["time"] = time
		reset_and_attach_ball()
		#show_stage_clear()


func on_combo_timer_timeout() -> void:
	combo = 0
	hide_combo()
