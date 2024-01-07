extends Node2D

@export var circle_scene: PackedScene
@export var cross_scene: PackedScene

@onready var border: Sprite2D = $Border
@onready var next_panel: Panel = $SidePanel/NextPanel

var border_size: Vector2 = Vector2.ZERO
var cell_size: Vector2 = Vector2.ZERO
var grid_pos: Vector2i = Vector2i.ZERO
var grid_data: Array
var player: int
var next_player_instance: Node


func _ready() -> void:
	border_size = border.texture.get_size()
	cell_size = border_size / 3
	player = 1
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
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					make_player(player, Vector2((grid_pos.y + 0.5) * cell_size.x, (grid_pos.x + 0.5) * cell_size.y))
					player = player * (-1)
					next_player(player)
				print(grid_data)


func new_game() -> void:
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
	]


func make_player(player: int, position: Vector2) -> void:
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.global_position = position
		add_child(circle)
	if player == -1:
		var cross = cross_scene.instantiate()
		cross.global_position = position
		add_child(cross)


func next_player(player: int) -> void:
	if is_instance_valid(next_player_instance):
		next_player_instance.queue_free()
	
	var postion: Vector2 = next_panel.global_position + next_panel.size/2
	if player == 1:
		next_player_instance = circle_scene.instantiate()
	if player == -1:
		next_player_instance = cross_scene.instantiate()
	next_player_instance.scale = Vector2.ONE
	next_player_instance.global_position = postion
	add_child(next_player_instance)
