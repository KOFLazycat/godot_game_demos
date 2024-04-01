class_name Game
extends Node2D

@export var game_over_scene: PackedScene = preload("res://src/main/scene/ui/game_over/game_over.tscn")
@export var stage_clear_scene: PackedScene = preload("res://src/main/scene/ui/stage_clear/stage_clear.tscn")
@export var brick_scene: PackedScene = preload("res://src/main/scene/role/brick/brick.tscn")
@export var brick_energy: int = 10
@export var energy_brick_energy: int = 100
@export var max_energy: int = 100

@onready var ball: Ball = $Ball
@onready var paddle: Paddle = $Paddle
@onready var energy_bar: Control = $HUDCanvasLayer/EnergyBar
@onready var health_bar: Control = $HUDCanvasLayer/HealthBar
@onready var score_ui: Control = $HUDCanvasLayer/Score
@onready var combo_lbl: Label = $Comber
@onready var combo_timer: Timer = $ComboTimer
@onready var spawn_pos_container: Node = $SpawnPos
@onready var bricks_container: Node = $Bricks
@onready var death_area: Area2D = $DeathArea
@onready var camera_2d: Camera2D = $Camera2D
@onready var ui_canvas_layer: CanvasLayer = $UICanvasLayer

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
	
	Globals.camera = camera_2d
	Globals.camera.objects = [ball]
	
	# 信号连接
	paddle.start.connect(on_paddle_start)
	combo_timer.timeout.connect(on_combo_timer_timeout)
	ball.hit_brick.connect(on_ball_hit_brick)
	death_area.body_entered.connect(on_death_area_body_entered)
	
	hide_combo()
	
	ball.attached_to = paddle.launch_point
	paddle.ball_attached = ball
	paddle.ball = ball
	
	for brick in get_tree().get_nodes_in_group("Bricks"):
		brick.energy_brick_destroyed.connect(on_energy_brick_destroyed)
		
	# Remove for testing with predefined bricks
	remove_all_bricks()
	layout_bricks()


func _process(delta) -> void:
	if not started: 
		return
	time += delta


######### Bricks ###########
# 移除所有brick
func remove_all_bricks() -> void:
	bricks.clear()
	bricks_to_destroy.clear()
	for brick in bricks_container.get_children():
		brick.queue_free()


func layout_bricks() -> void:
	var bricks_tween: Tween = create_tween()
	var max_bricks: int = spawn_pos_container.get_child_count()
	#max_bricks = 3
	for i in range(max_bricks):
		# 90% chance of having a block
		if randf() < 0.1: 
			continue
		# bricks 逐个创建
		bricks_tween.tween_callback(add_brick.bind(spawn_pos_container.get_child(i).global_position))
		bricks_tween.tween_interval(0.1)
		#add_brick(spawn_pos_container.get_child(i).global_position)


func add_brick(pos: Vector2) -> void:
	var brick_instance = brick_scene.instantiate()
	bricks_container.add_child(brick_instance)
	brick_instance.energy_brick_destroyed.connect(on_energy_brick_destroyed)
	brick_instance.destroyed.connect(on_brick_destroyed)
	brick_instance.global_position = pos
	bricks.append(brick_instance)
	if brick_instance.type != brick_instance.TYPE.EXPLOSIVE and brick_instance.type != brick_instance.TYPE.ENERGY:
		bricks_to_destroy.append(brick_instance)


######### Ball ###########
func reset_and_attach_ball() -> void:
	ball.velocity = Vector2.ZERO
	ball.attached_to = paddle.launch_point
	ball.appear()
	paddle.ball_attached = ball
	paddle.game_over = false
	paddle.stage_clear = false


######### Energy Health Score ###########
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


func reset_health() -> void:
	health = 3
	health_bar.set_health(health)
	
func reset_score() -> void:
	score = 0
	score_ui.set_score(score)


######### Combo ###########
func show_combo(combo: int) -> void:
	combo_lbl.text = "COMBO " + str(combo)
	combo_lbl.visible = true


func hide_combo() -> void:
	combo_lbl.visible = false


######### GameOver ###########
func show_game_over() -> void:
	var game_over_instance = game_over_scene.instantiate()
	ui_canvas_layer.add_child(game_over_instance)
	game_over_instance.retry.connect(on_game_over_retry)


######### StageClear ###########
func show_stage_clear() -> void:
	var stage_clear_instance = stage_clear_scene.instantiate()
	ui_canvas_layer.add_child(stage_clear_instance)
	stage_clear_instance.next.connect(on_stage_clear_next)


######### SIGNALS ###########

func on_paddle_start() -> void:
	started = true


func on_energy_brick_destroyed() -> void:
	add_energy(energy_brick_energy)


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
		show_stage_clear()


func on_combo_timer_timeout() -> void:
	combo = 0
	hide_combo()


func on_ball_hit_brick(brick: Brick) -> void:
	add_energy(brick_energy)
	if !is_instance_valid(brick) or brick._destroyed: 
		return
	combo += 1
	show_combo(combo)
	combo_timer.start()
	score += score_brick_touched * combo
	Globals.stats["score"] = score
	score_ui.set_score(score)


func on_game_over_retry() -> void:
	reset_and_attach_ball()
	reset_health()
	reset_energy()
	reset_score()
	time = 0.0
	Globals.reset_stats()
	remove_all_bricks()
	layout_bricks()


func on_death_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Ball"): 
		return
	health -= 1
	health = int(clamp(health, 0, 3))
	
	health_bar.set_health(health)
	
	body.die()
	
	if health == 0:
		paddle.game_over = true
		show_game_over()
		return
	reset_and_attach_ball()


func on_stage_clear_next() -> void:
	reset_and_attach_ball()
	reset_health()
	reset_energy()
	reset_score()
	time = 0.0
	Globals.reset_stats()
	remove_all_bricks()
	layout_bricks()
