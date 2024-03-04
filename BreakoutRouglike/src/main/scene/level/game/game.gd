class_name Game
extends Node2D

@onready var ball: Ball = $Ball
@onready var paddle: Paddle = $Paddle
@onready var energy_bar: Control = $CanvasLayer/EnergyBar
@onready var health_bar: Control = $CanvasLayer/HealthBar
@onready var score_ui: Control = $CanvasLayer/Score
@onready var combo_lbl: Label = $Comber

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
	
	hide_combo()
	
	ball.attached_to = paddle.launch_point
	paddle.ball_attached = ball
	paddle.ball = ball
	
	#for brick in get_tree().get_nodes_in_group("Bricks"):
		#brick.energy_brick_destroyed.connect(on_energy_brick_destroyed)
		#
	## Remove for testing with predefined bricks
	#remove_all_bricks()
	#layout_bricks()


func hide_combo() -> void:
	combo_lbl.visible = false


func on_paddle_start() -> void:
	started = true
