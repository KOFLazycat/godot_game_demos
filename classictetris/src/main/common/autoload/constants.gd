extends Node

enum TETROMINO {
	I, O, T, J, L, S, Z
}

const CELLS = {
	#-------------------------------------------------------------------
	TETROMINO.I: [Vector2(-1, 0), Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	#-------------------------------------------------------------------
	TETROMINO.J: [Vector2(-1, 1), Vector2(-1, 0), Vector2(0,0), Vector2(1, 0 )],
	#-------------------------------------------------------------------
	TETROMINO.L: [Vector2(1,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	TETROMINO.O: [Vector2(0,1), Vector2(1,1), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	TETROMINO.S: [Vector2(0,1), Vector2(1,1), Vector2(-1, 0), Vector2(0,0)],
	#-------------------------------------------------------------------
	TETROMINO.T: [Vector2(0,1), Vector2(-1, 0), Vector2(0,0), Vector2(1,0)],
	#-------------------------------------------------------------------
	TETROMINO.Z: [Vector2(-1, 1), Vector2(0, 1), Vector2(0,0), Vector2(1, 0)]
}

const WALL_KICKS_I = [
	[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,-1), Vector2(1,2)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2,0), Vector2(-1,2), Vector2(2, -1)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2, 0), Vector2(1, -2), Vector2(-2, 1)],
	[Vector2(0,0), Vector2(2,0), Vector2(-1, 0), Vector2(2,1), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(-2,0), Vector2(1, 0), Vector2(-2, -1), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1, -2), Vector2(-2,1)],
	[Vector2(0,0), Vector2(-1, 0), Vector2(2, 0), Vector2(-1,2), Vector2(2, -1)]
]

const WALL_KICKS_JLOSTZ = [
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, -1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1,-1), Vector2(0,2), Vector2(1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, 1), Vector2(0, -2), Vector2(-1, -2)],
	[Vector2(0,0), Vector2(1,0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1, -1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0, 2), Vector2(-1, 2)],
	[Vector2(0,0), Vector2(1, 0), Vector2(1, 1), Vector2(0,-2), Vector2(1, -2)]
]

const DATA = {
	TETROMINO.I: preload("res://src/main/assets/resources/i_piece_data.tres"),
	TETROMINO.J: preload("res://src/main/assets/resources/j_piece_data.tres"),
	TETROMINO.L: preload("res://src/main/assets/resources/l_piece_data.tres"),
	TETROMINO.O: preload("res://src/main/assets/resources/o_piece_data.tres"),
	TETROMINO.S: preload("res://src/main/assets/resources/s_piece_data.tres"),
	TETROMINO.T: preload("res://src/main/assets/resources/t_piece_data.tres"),
	TETROMINO.Z: preload("res://src/main/assets/resources/z_piece_data.tres")
}

# 顺时针旋转矩阵
const CLOCKWISE_ROTATION_MATRIX = [Vector2(0, -1), Vector2(1, 0)]
# 逆时针旋转矩阵
const COUNTER_CLOCKWISE_ROTATION_MATRIX = [Vector2(0,1), Vector2(-1, 0)]
# 每格方块长宽
const PIECE_SIZE: Vector2 = Vector2(42, 42)
# 方块边框范围
const MIN_BOUNDS_X: float = 46
const MIN_BOUNDS_Y: float = 46
const MAX_BOUNDS_X: float = 424
const MAX_BOUNDS_Y: float = 886
# 行列数
const ROW_COUNT: int = 20
const COLUMN_COUNT: int = 10
