extends Control

@onready var panel_container: PanelContainer = $PanelContainer


func add_next_tetromino(tetromino: Tetromino, spawn_position: Vector2) -> void:
	if tetromino:
		tetromino.scale = Vector2(0.5, 0.5)
		panel_container.add_child(tetromino)
		tetromino.set_position(spawn_position)
		#tetromino.global_position = spawn_position
