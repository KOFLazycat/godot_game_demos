extends Node2D

@onready var castle: Node2D = $Castle
@onready var tiny_defence_archer_right: TinyDefenceArcher = $TinyDefenceArcherRight
@onready var tiny_defence_archer_left: TinyDefenceArcher = $TinyDefenceArcherLeft
@onready var timer: Timer = $Timer
@onready var tiny_defence_torch_tscn: PackedScene = preload("res://entities/enemy/tiny_defence_torch/tiny_defence_torch.tscn") as PackedScene
@onready var tiny_defence_tnt_tscn: PackedScene = preload("res://entities/enemy/tiny_defence_tnt/tiny_defence_tnt.tscn") as PackedScene
@onready var marker_2d_left: Marker2D = $Marker2DLeft
@onready var marker_2d_right: Marker2D = $Marker2DRight


func _ready() -> void:
	tiny_defence_archer_right.global_position = castle.marker_2d_right.global_position
	tiny_defence_archer_left.global_position = castle.marker_2d_left.global_position
	tiny_defence_archer_left.animated_sprite_2d.flip_h = true
	tiny_defence_archer_right.animated_sprite_2d.flip_h = false
	
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout() -> void:
	# left
	var tiny_defence_tnt_left: CharacterBody2D = tiny_defence_tnt_tscn.instantiate() as CharacterBody2D
	tiny_defence_tnt_left.animated_sprite_2d_flip_h = false
	tiny_defence_tnt_left.global_position = marker_2d_left.global_position + Vector2(randf_range(-20, 20), randf_range(-15, 15))
	tiny_defence_tnt_left.scale = Vector2(0.5, 0.5)
	add_child(tiny_defence_tnt_left)
	# right
	var tiny_defence_tnt_right: CharacterBody2D = tiny_defence_tnt_tscn.instantiate() as CharacterBody2D
	tiny_defence_tnt_right.animated_sprite_2d_flip_h = true
	tiny_defence_tnt_right.global_position = marker_2d_right.global_position + Vector2(randf_range(-20, 20), randf_range(-15, 15))
	tiny_defence_tnt_right.scale = Vector2(0.5, 0.5)
	add_child(tiny_defence_tnt_right)
	timer.stop()
