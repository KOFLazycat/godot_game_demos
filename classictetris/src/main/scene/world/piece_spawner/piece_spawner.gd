extends Node
class_name PieceSpawner

@onready var board: Board = $"../Board"

var current_tetromino: Constants.TETROMINO
var next_tetromino: Constants.TETROMINO
var is_game_over: bool = false


func _ready():
	current_tetromino = Constants.TETROMINO.values().pick_random()	
	next_tetromino = Constants.TETROMINO.values().pick_random()	 
	board.spawn_tetromino(current_tetromino, false)
	#board.spawn_tetromino(next_tetromino, true, Vector2(100, 50))
	
