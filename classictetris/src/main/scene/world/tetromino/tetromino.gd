extends Node2D
class_name Tetromino

@onready var timer = $Timer
@onready var piece_scene = preload("res://src/main/scene/world/Piece/piece.tscn")
#@onready var ghost_tetromino_scene = preload("res://Scenes/ghost_tetromino.tscn")

var tetromino_resource: Resource
var pieces: Array = [] # 当前移动方块的Piece
var other_tetrominoes_pieces: Array = [] # 目前所有已锁定方块
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
	
	timer.timeout.connect(_on_timer_timeout)


# 按照指定方向移动一格，并判断能否移动成功（出界或者发送碰撞，移动均不能成功）
func move(direction: Vector2) -> bool:
	var new_position: Vector2 = calculate_global_position(direction, global_position)
	if new_position != Vector2.ZERO:
		global_position = new_position
		#if direction != Vector2.DOWN:
			#hard_drop_ghost.call_deferred()
		return true
	return false


# 计算新位置的坐标
func calculate_global_position(direction: Vector2, starting_global_position: Vector2) -> Vector2:
	# 与其他方块的碰撞检测
	if is_colliding_with_other_tetrominos(direction, starting_global_position):
		return Vector2.ZERO
	#TODO: check for collision with game bounds
	if !is_within_game_bounds(direction, starting_global_position):
		return Vector2.ZERO
	return starting_global_position + direction * pieces[0].get_size().x


# 是否出界
func is_within_game_bounds(direction: Vector2, starting_global_position: Vector2) -> bool:
	for piece in pieces:
		var new_position: Vector2 = piece.position + starting_global_position + direction * piece.get_size()
		if new_position.x < Constants.MIN_BOUNDS_X || new_position.x > Constants.MAX_BOUNDS_X || new_position.y >= Constants.MAX_BOUNDS_Y:
			return false
	return true


# 检测是否会与其他方块发生碰撞
func is_colliding_with_other_tetrominos(direction: Vector2, starting_global_position: Vector2) -> bool:
	for tetromino_piece in other_tetrominoes_pieces:
		for piece in pieces:
			if starting_global_position + piece.position + direction * piece.get_size() == tetromino_piece.global_position:
				return true
	return false


# 输入
func _input(_event):
	if Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
	#elif Input.is_action_just_pressed("hard_drop"):
		#hard_drop()
	#elif Input.is_action_just_pressed("rotate_anticlockwise"):
		#rotate_tetromino(-1)
	#elif Input.is_action_just_pressed("rotate_clockwise"):
		#rotate_tetromino(1)


func _on_timer_timeout() -> void:
	# 不能移动时，锁定方块
	move(Vector2.DOWN)
