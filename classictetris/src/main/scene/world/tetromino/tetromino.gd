extends Node2D
class_name Tetromino

# 自动下落计时器
@onready var auto_move_down_timer: Timer = $AutoMoveDownTimer
# 持续移动计时器
@onready var continuous_move_timer: Timer = $ContinuousMoveTimer
# harddrop 冷却时间
@onready var hard_drop_cold_down_timer: Timer = $HardDropColdDownTimer
@onready var piece_scene = preload("res://src/main/scene/world/piece/piece.tscn")
@onready var ghost_tetromino_scene = preload("res://src/main/scene/world/ghost_tetromino/ghost_tetromino.tscn")

var tetromino_resource: Resource
var pieces: Array = [] # 当前移动方块的Piece
var other_tetrominoes_pieces: Array = [] # 目前所有已锁定方块
var is_next_piece: bool
var rotation_index: int = 0
var tetromino_cells: Array = []
var wall_kicks: Array = []
var current_move_direction: Vector2 = Vector2.ZERO # 当前移动方向
var is_hard_drop: bool = false # 是否使用hard_drop
var ghost_tetromino

# 锁定指定方块信号
signal lock_tetromino(tetromino: Tetromino, is_hard_drop: bool)


func _ready():
	tetromino_cells = Constants.cells[tetromino_resource.tetromino_type]
	for cell in tetromino_cells:
		var piece = piece_scene.instantiate() as Piece
		pieces.append(piece)
		add_child(piece)
		piece.set_texture(tetromino_resource.piece_texture)
		piece.position = cell * piece.get_size()
	
	if is_next_piece == false:
		position = tetromino_resource.spawn_position	
		wall_kicks = Constants.WALL_KICKS_I if (tetromino_resource.tetromino_type == Constants.TETROMINO.I) else Constants.WALL_KICKS_JLOSTZ
		ghost_tetromino = ghost_tetromino_scene.instantiate() as GhostTetromino
		ghost_tetromino.tetromino_resource = tetromino_resource
		get_tree().root.add_child.call_deferred(ghost_tetromino)
		hard_drop_ghost.call_deferred()
		
		# 计算方块下落的计时器时间，等级越高时间越短
		var cur_level: int = LoadSaveSystem.load_level()
		auto_move_down_timer.wait_time = pow(0.8 - (cur_level - 1) * 0.007, cur_level - 1)
		auto_move_down_timer.start()
	else:
		set_process_input(false)
	
	auto_move_down_timer.timeout.connect(_on_auto_move_down_timer_timeout)
	continuous_move_timer.timeout.connect(_on_continuous_move_timer_timeout)


# 按照指定方向移动一格，并判断能否移动成功（出界或者发送碰撞，移动均不能成功）
func move(direction: Vector2 = Vector2.ZERO) -> bool:
	if direction == Vector2.ZERO:
		direction = current_move_direction
	var new_position: Vector2 = calculate_global_position(direction, global_position)
	if new_position != Vector2.ZERO:
		global_position = new_position
		if direction != Vector2.DOWN:
			hard_drop_ghost.call_deferred()
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
		if tetromino_piece:
			for piece in pieces:
				if starting_global_position + piece.position + direction * piece.get_size() == tetromino_piece.global_position:
					return true
	return false


# 旋转方块
func rotate_tetromino(direction: int) -> void:
	# 旋转音效
	AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.ROTATE)
	# 每次旋转90度，所以方块旋转方向应该有0-3四个状态，通过顺时针、逆时针相互切换状态
	var original_rotation_index: int = rotation_index
	# O型方块不需要旋转
	if tetromino_resource.tetromino_type == Constants.TETROMINO.O:
		return
	
	apply_rotation(direction)
	
	rotation_index = wrap(rotation_index + direction, 0, 4)
	
	if !test_wall_kicks(rotation_index, direction):
		rotation_index = original_rotation_index
		apply_rotation(-direction)
	
	hard_drop_ghost.call_deferred()


# 测试墙踢
func test_wall_kicks(rot_index: int, rotation_direction: int) -> bool:
	var wall_kick_index = get_wall_kick_index(rot_index, rotation_direction)
	
	for i in wall_kicks[0].size():
		var translation = wall_kicks[wall_kick_index][i]
		# 将方块踢离墙壁
		if move(translation):
			return true
	return false


# 获取墙踢矩阵索引
func get_wall_kick_index(rot_index: int, rotation_direction: int) -> int:
	var wall_kick_index: int = rot_index * 2
	if rotation_direction < 0:
		wall_kick_index -= 1
		
	return wrap(wall_kick_index, 0 , wall_kicks.size())


# 矩阵旋转
func apply_rotation(direction: int) -> void:
	# 获取对应的旋转矩阵
	var rotation_matrix: Array = Constants.CLOCKWISE_ROTATION_MATRIX if direction == 1 else Constants.COUNTER_CLOCKWISE_ROTATION_MATRIX
	
	for i in tetromino_cells.size():
		var cell = tetromino_cells[i]
		# 旋转90或者-90之后坐标
		var coordinates: Vector2 = rotation_matrix[0] * cell.x + rotation_matrix[1]* cell.y
		tetromino_cells[i] = coordinates
	
	for i in pieces.size():
		var piece = pieces[i]
		# 更新方块位置
		piece.position = tetromino_cells[i] * piece.get_size()


# 快速下落
func hard_drop() -> void:
	# harddrop 音效
	AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.HARD_DROP)
	while(move(Vector2.DOWN)):
		is_hard_drop = true
		continue
	lock()
	
	if is_hard_drop:
		for piece in pieces:
			if is_instance_valid(piece):
				piece.hard_drop_flash.play_flash()
		
	is_hard_drop = false


func hard_drop_ghost() -> Vector2:
	var final_hard_drop_position: Vector2 = Vector2.ZERO
	var ghost_position_update: Vector2 = calculate_global_position(Vector2.DOWN, global_position)
	
	while ghost_position_update != Vector2.ZERO:
		# 不停下移，以获取最终ghost位置
		ghost_position_update = calculate_global_position(Vector2.DOWN, ghost_position_update)
		if ghost_position_update != Vector2.ZERO:
			final_hard_drop_position = ghost_position_update
	
	if final_hard_drop_position != Vector2.ZERO:
		var children: Array[Node] = get_children().filter(func (c): return c is Piece)
		var pieces_position: Array[Vector2] = []
		for i in children.size():
			var piece_position: Vector2 = children[i].position
			pieces_position.append(piece_position)
		
		ghost_tetromino.set_ghost_tetromino(final_hard_drop_position, pieces_position)
	
	return final_hard_drop_position


# 固定方块，不能移动
func lock() -> void:
	auto_move_down_timer.stop()
	lock_tetromino.emit(self, is_hard_drop)
	set_process_input(false)
	ghost_tetromino.queue_free()


# 输入
func _input(event):
	# 只接受键盘和触屏控制
	if event is not InputEventKey and event is not InputEventScreenTouch:
		return
	if Input.is_action_just_pressed("left"):
		# 移动音效
		AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.MOVE)
		current_move_direction = Vector2.LEFT
		move(current_move_direction)
		continuous_move_timer.start()
	elif Input.is_action_just_pressed("right"):
		# 移动音效
		AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.MOVE)
		current_move_direction = Vector2.RIGHT
		move(current_move_direction)
		continuous_move_timer.start()
	elif Input.is_action_just_pressed("down"):
		# 移动音效
		AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.MOVE)
		current_move_direction = Vector2.DOWN
		move(current_move_direction)
		continuous_move_timer.start()
	elif Input.is_action_just_pressed("hard_drop"):
			hard_drop()
	elif Input.is_action_just_pressed("rotate_anticlockwise"):
		rotate_tetromino(-1)
	elif Input.is_action_just_pressed("rotate_clockwise"):
		rotate_tetromino(1)
	elif Input.is_action_just_released("left") or Input.is_action_just_released("right") or Input.is_action_just_released("down"):
		continuous_move_timer.stop()


func _on_auto_move_down_timer_timeout() -> void:
	# 不能移动时，锁定方块
	var should_lock: bool =  !move(Vector2.DOWN)
	if should_lock:
		lock()


func _on_continuous_move_timer_timeout() -> void:
	# 移动音效
	AudioSystem.play_sfx(AudioSystem.SFXS_INDEX.MOVE)
	# 持续移动
	move(current_move_direction)
