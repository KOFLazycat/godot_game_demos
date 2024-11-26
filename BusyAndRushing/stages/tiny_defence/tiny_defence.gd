extends Node2D

@onready var castle: Node2D = $Castle
@onready var archer: Node = $Archer
@onready var archer_tscn: PackedScene = preload("res://entities/player/tiny_defence_archer/tiny_defence_archer.tscn") as PackedScene


func _ready() -> void:
	# archer left
	var archer_left = archer_tscn.instantiate()
	archer_left.scale = Vector2(0.5, 0.5)
	archer_left.global_position = castle.marker_2d_left.global_position
	archer_left.animated_sprite_2d_flip_h = true
	archer.add_child(archer_left)
	# archer right
	var archer_right = archer_tscn.instantiate()
	archer_right.scale = Vector2(0.5, 0.5)
	archer_right.global_position = castle.marker_2d_right.global_position
	archer_right.animated_sprite_2d_flip_h = false
	archer.add_child(archer_right)
