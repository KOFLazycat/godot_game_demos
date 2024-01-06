extends Node2D

@onready var border: Sprite2D = $Border

var border_size: Vector2 = Vector2.ZERO
var cell_size: Vector2 = Vector2.ZERO
var grid_pos: Vector2i = Vector2i.ZERO
var grid_data: Array
var player: int


func _ready() -> void:
	border_size = border.texture.get_size()
	cell_size = border_size / 3
	new_game()


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
					player = player * (-1)
				print(grid_data)


func new_game() -> void:
	player = 1
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0],
	]
