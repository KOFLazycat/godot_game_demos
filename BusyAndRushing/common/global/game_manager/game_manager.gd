extends Node2D

@onready var game_over_timer: Timer = $GameOverTimer

var _is_game_over: bool = false


func _ready() -> void:
	game_over_timer.timeout.connect(on_game_over_timer_timeout)


func reset_game_state():
	_is_game_over = false


func is_game_over() -> bool:
	return _is_game_over



func set_game_over():
	_is_game_over = true
	get_tree().paused = true
	#game_over_timer.start()


func on_game_over_timer_timeout() -> void:
	get_tree().paused = true
