extends Node
class_name Board

@export var tetromino_scene: PackedScene

@onready var line_scene = preload("res://src/main/scene/world/line/line.tscn")
@onready var ui: Control = $"../UI"


const PIECE_SIZE: Vector2 = Vector2(42, 42)
var next_tetromino: Tetromino
var tetrominos: Array[Tetromino] = []
var clear_lines_count: int = 0

# 方块已锁定信号
signal tetromino_locked
# 游戏结束
signal game_over


func _ready() -> void:
	pass


# 生产方块
func spawn_tetromino(type: Constants.TETROMINO, is_next_piece: bool = false, spawn_position: Vector2 = Vector2.ZERO) -> void:
	var tetromino_resource: Resource = Constants.DATA[type]
	var tetromino = tetromino_scene.instantiate() as Tetromino
	
	tetromino.tetromino_resource = tetromino_resource
	tetromino.is_next_piece = is_next_piece
	
	if is_next_piece == false:
		var other_pieces = get_all_pieces()
		tetromino.position = tetromino_resource.spawn_position
		tetromino.other_tetrominoes_pieces = other_pieces
		add_child(tetromino)
		tetromino.lock_tetromino.connect(_on_tetromino_locked)
	else:
		ui.add_next_tetromino(tetromino, spawn_position)
		next_tetromino = tetromino


# 获取所有行
func get_lines() -> Array[Node]:
	return get_children().filter(func (c): return c is Line)


# 获取所有方块
func get_all_pieces() -> Array[Node]:
	var pieces: Array[Node] = []
	for line in get_lines():
		pieces.append_array(line.get_children())
	return pieces


# 添加Piece进Line
func add_tetromino_to_lines(tetromino: Tetromino) -> void:
	var tetromino_pieces: Array[Node] = tetromino.get_children().filter(func (c): return c is Piece)
	
	for piece in tetromino_pieces:
		var y_position = piece.global_position.y
		## 用来判断对应高度Line是否已经存在，如果不存在，创建新的Line
		var does_line_for_piece_exists = false
		
		for line in get_lines():
			if line.global_position.y == y_position:
				# 重置父节点
				piece.reparent(line)
				does_line_for_piece_exists = true
		
		if !does_line_for_piece_exists:
			var piece_line = line_scene.instantiate() as Line
			piece_line.global_position = Vector2(0, y_position)
			add_child(piece_line)
			# 重置父节点
			piece.reparent(piece_line)


# 删除已经满了的Line
func remove_full_lines():
	for line in get_lines():
		if line.is_line_full(Constants.COLUMN_COUNT):
			move_lines_down(line.global_position.y)
			line.free()
			clear_lines_count += 1
			# 消除音效
			AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.CLEAR)


# Line向下移动
# y_position_remove 即将移除Line的 global_position.y
func move_lines_down(y_position_remove: float) -> void:
	for line in get_lines():
		if line.global_position.y < y_position_remove:
			line.global_position.y += Constants.PIECE_SIZE.x


# 检查游戏是否结束
func check_game_over() -> void:
		for piece in get_all_pieces():
			if piece.global_position.y <= Constants.MIN_BOUNDS_Y:
				game_over.emit()
				# 游戏结束
				AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.GAME_OVER)


# 方块锁定信号处理函数
func _on_tetromino_locked(tetromino: Tetromino, is_hard_drop: bool) -> void:
	next_tetromino.queue_free()
	# 保存已锁定方块
	tetrominos.append(tetromino)
	add_tetromino_to_lines(tetromino)
	
	# 如果是harddrop锁定，播放方块整体会下顿一次
	if is_hard_drop:
		for piece in get_all_pieces():
			if piece.global_position.y > Constants.MIN_BOUNDS_Y:
				var tmp_pos: Vector2 = piece.position
				var tween: Tween = create_tween()
				tween.tween_property(piece, "position", Vector2(tmp_pos.x, tmp_pos.y + 10), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
				tween.tween_property(piece, "position", tmp_pos, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# 清理可消除行
	remove_full_lines()
	# 更新分数和等级
	#print(clear_lines_count)
	ui.update_score_value(clear_lines_count)
	ui.update_level_value(clear_lines_count)
	# 方块已锁定信号发出
	tetromino_locked.emit()
	check_game_over()
