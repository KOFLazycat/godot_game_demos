extends Node2D

## 砍伐音效
@export var coin_sfx: Array[AudioSFXFXRequest]

@onready var game_over_timer: Timer = $GameOverTimer

var _is_game_over: bool = false
var _game_score: int = 0
var _history_max: int = 0


func _ready() -> void:
	reset_game_state()
	game_over_timer.timeout.connect(on_game_over_timer_timeout)


func reset_game_state():
	_is_game_over = false
	_history_max = LoadSaveSystem.load_history_max()


func get_game_score() -> int:
	return _game_score


func get_history_max() -> int:
	return _history_max


func add_game_score(s: int) -> void:
	AudioMasterAutoload.PlayFX(coin_sfx.pick_random())
	_game_score += s
	if _game_score > _history_max:
		_history_max = _game_score
	#LoadSaveSystem.save_score(_game_score)


func is_game_over() -> bool:
	return _is_game_over


func set_game_over():
	_is_game_over = true
	LoadSaveSystem.save_history_max(_history_max)
	get_tree().paused = true


func on_game_over_timer_timeout() -> void:
	get_tree().paused = true
