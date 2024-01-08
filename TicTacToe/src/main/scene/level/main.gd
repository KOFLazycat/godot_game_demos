extends Node2D

@export var circle_scene: PackedScene
@export var cross_scene: PackedScene
@export var game_over_menu_scene: PackedScene

@onready var border: Sprite2D = $Border
@onready var next_panel: Panel = $SidePanel/NextPanel

var border_size: Vector2 = Vector2.ZERO
var cell_size: Vector2 = Vector2.ZERO
var grid_pos: Vector2i = Vector2i.ZERO
var grid_data: Array
var player: int
var next_player_instance: Node
var winner: int
var is_game_over: bool


func _ready() -> void:
	new_game()
	next_player(player)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if (event.position.x <= border_size.x) and (event.position.y <= border_size.y):
				## 井横坐标
				grid_pos.y = event.position.x / cell_size.x
				## 井纵坐标
				grid_pos.x = event.position.y / cell_size.y
				if !is_game_over:
					if grid_data[grid_pos.y][grid_pos.x] == 0:
						grid_data[grid_pos.y][grid_pos.x] = player
						make_player(player, Vector2((grid_pos.y + 0.5) * cell_size.x, (grid_pos.x + 0.5) * cell_size.y))
						check_game_over()
						player = player * (-1)
						next_player(player)


func new_game() -> void:
	border_size = border.texture.get_size()
	cell_size = border_size / 3
	player = 1
	winner = 0
	is_game_over = false
	
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
	]


func make_player(player_v: int, position_v: Vector2) -> void:
	if player_v == 1:
		var circle = circle_scene.instantiate()
		circle.global_position = position_v
		add_child(circle)
	if player_v == -1:
		var cross = cross_scene.instantiate()
		cross.global_position = position_v
		add_child(cross)


func next_player(player_v: int) -> void:
	if is_instance_valid(next_player_instance):
		next_player_instance.queue_free()
	
	var postion: Vector2 = next_panel.global_position + next_panel.size/2
	if player_v == 1:
		next_player_instance = circle_scene.instantiate()
	if player_v == -1:
		next_player_instance = cross_scene.instantiate()
	next_player_instance.scale = Vector2.ONE
	next_player_instance.global_position = postion
	add_child(next_player_instance)


func check_game_over() -> void:
	var all_sum_abs: int = 0
	for i in grid_data.size():
		var row_sum: int = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		var clo_sum: int = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		all_sum_abs += abs(grid_data[i][0]) + abs(grid_data[i][1]) + abs(grid_data[i][2])
		var diag_sum_1: int = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		var diag_sum_2: int = grid_data[2][0] + grid_data[1][1] + grid_data[0][2]
		if row_sum == 3 || clo_sum == 3 || diag_sum_1 == 3 || diag_sum_2 == 3:
			is_game_over = true
			winner = 1
			break
		if row_sum == -3 || clo_sum == -3 || diag_sum_1 == -3 || diag_sum_2 == -3:
			is_game_over = true
			winner = -1
			break
	# 判断是否是和局
	if all_sum_abs == 9:
		is_game_over = true
		winner = 0
		
	if is_game_over:
		game_over()


func game_over() -> void:
	var game_over_menu_instance = game_over_menu_scene.instantiate()
	game_over_menu_instance.global_position = Vector2(450, 300)
	add_child(game_over_menu_instance)
	match winner:
		-1:
			game_over_menu_instance.result_label.text = "Player 2 Win!"
		0:
			game_over_menu_instance.result_label.text = "Draw!!!"
		1:
			game_over_menu_instance.result_label.text = "Player 1 Win!"
