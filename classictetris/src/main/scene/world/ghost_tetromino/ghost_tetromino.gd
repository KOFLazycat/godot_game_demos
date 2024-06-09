extends Node2D
class_name GhostTetromino

@onready var piece_scene: PackedScene = preload("res://src/main/scene/world/piece/piece.tscn")
@onready var ghost_texture = preload("res://src/main/assets/textures/tile40.png")

var tetromino_resource: Resource


func _ready():
	var tetromino_cells: Array = Constants.cells[tetromino_resource.tetromino_type]
	
	for cell in tetromino_cells:
		var piece = piece_scene.instantiate() as Piece
		add_child(piece)
		piece.set_texture(ghost_texture)
		piece.position = cell * piece.get_size()


func set_ghost_tetromino(new_position: Vector2, pieces_position: Array[Vector2]):
	global_position = new_position
	var pieces = get_children()
	for i in pieces.size():
		pieces[i].position = pieces_position[i]
