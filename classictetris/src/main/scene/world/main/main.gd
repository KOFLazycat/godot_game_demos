extends Node2D

@onready var ui: Control = $UI
@onready var board: Board = $Board

var current_tetromino: Constants.TETROMINO
var next_tetromino: Constants.TETROMINO
var is_game_over: bool = false


func _ready() -> void:
	init_tetromino()


func init_tetromino() -> void:
	current_tetromino = Constants.TETROMINO.values().pick_random()	
	next_tetromino = Constants.TETROMINO.values().pick_random()
	board.spawn_tetromino(current_tetromino, false)
	board.spawn_tetromino(next_tetromino, true, Vector2(100, 90)) # Next 方块出现位置
	board.tetromino_locked.connect(_on_tetromino_locked)
	board.game_over.connect(_on_game_over)


# 方块已锁定信号处理函数
func _on_tetromino_locked():
	if is_game_over:
		return
	current_tetromino = next_tetromino
	next_tetromino = Constants.TETROMINO.values().pick_random()	
	board.spawn_tetromino(current_tetromino, false)
	board.spawn_tetromino(next_tetromino, true, Vector2(100, 90)) # Next 方块出现位置


func _on_game_over():
	is_game_over = true
	#ui.show_game_over()