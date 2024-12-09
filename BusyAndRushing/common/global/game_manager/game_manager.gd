extends Node2D

## 砍伐音效
@export var coin_sfx: Array[AudioSFXFXRequest]

@onready var game_over_timer: Timer = $GameOverTimer

var _is_game_over: bool = false
var _game_score: int = 0


func _ready() -> void:
	reset_game_state()
	game_over_timer.timeout.connect(on_game_over_timer_timeout)


func reset_game_state():
	_is_game_over = false
	#_game_score = LoadSaveSystem.load_score()


func get_game_score() -> int:
	return _game_score


func add_game_score(s: int) -> void:
	AudioMasterAutoload.PlayFX(coin_sfx.pick_random())
	_game_score += s
	#LoadSaveSystem.save_score(_game_score)


func is_game_over() -> bool:
	return _is_game_over


func set_game_over():
	_is_game_over = true
	get_tree().paused = true


func on_game_over_timer_timeout() -> void:
	get_tree().paused = true
