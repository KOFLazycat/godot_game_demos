extends Node2D
class_name Tetromino

@onready var timer = $Timer
@onready var piece_scene = preload("res://src/main/scene/world/Piece/piece.tscn")
#@onready var ghost_tetromino_scene = preload("res://Scenes/ghost_tetromino.tscn")

var tetromino_resource: Resource
var pieces: Array = []
var other_tetrominoes_pieces: Array = [] 
var is_next_piece: bool
var rotation_index: int = 0
var tetromino_cells: Array = []
var wall_kicks: Array = []
var ghost_tetromino

# 锁定方块信号
signal lock_tetromino(tetromino: Tetromino)


func _ready():
	tetromino_cells = Constants.CELLS[tetromino_resource.tetromino_type]
	for cell in tetromino_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(tetromino_resource.piece_texture)
		piece.position = cell * piece.get_size()
	
	if is_next_piece == false:
		position = tetromino_resource.spawn_position	
		wall_kicks = Constants.WALL_KICKS_I if (tetromino_resource.tetromino_type == Constants.TETROMINO.I) else Constants.WALL_KICKS_JLOSTZ
		#ghost_tetromino = ghost_tetromino_scene.instantiate() as GhostTetromino
		#ghost_tetromino.tetromino_resource = tetromino_resource
		#get_tree().root.add_child.call_deferred(ghost_tetromino)
		#hard_drop_ghost.call_deferred()
	else: 
		timer.stop()
		set_process_input(false)
