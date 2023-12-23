extends Node

## 游戏场景过渡数
@export var fade_out_speed: float = 1.0
@export var fade_in_speed: float = 1.0
@export var fade_out_pattern: String = "fade"
@export var fade_in_pattern: String = "fade"
@export var fade_out_smoothness = 0.1 # (float, 0, 1)
@export var fade_in_smoothness = 0.1 # (float, 0, 1)
@export var fade_out_inverted: bool = false
@export var fade_in_inverted: bool = false
@export var color: Color = Color(0, 0, 0)
@export var timeout: float = 0.0
@export var clickable: bool = false
@export var add_to_back: bool = true

@onready var fade_out_options = SceneManager.create_options(fade_out_speed, fade_out_pattern, fade_out_smoothness, fade_out_inverted)
@onready var fade_in_options = SceneManager.create_options(fade_in_speed, fade_in_pattern, fade_in_smoothness, fade_in_inverted)
@onready var general_options = SceneManager.create_general_options(color, timeout, clickable, add_to_back)

var total_score: int = 0
var _is_game_over: bool = false

var current_level: int = 1
var level_map: Dictionary = {
	1 : "res://src/main/scene/level/level_one/level_one.tscn",
}


## 启动场景过渡
func show_first_scene() -> void:
	general_options = SceneManager.create_general_options(color, 1.0, clickable, add_to_back)
	SceneManager.show_first_scene(fade_in_options, general_options)


## 场景过渡
func change_scene(scene: String) -> void:
	SceneManager.validate_scene(scene)
	# code breaks if pattern is not recognizable
	#SceneManager.validate_pattern(fade_out_pattern)
	#SceneManager.validate_pattern(fade_in_pattern)
	SceneManager.change_scene(scene, fade_out_options, fade_in_options, general_options)


## 重置游戏状态
func reset_game_state():
	_is_game_over = false
	total_score = 0


## 获取得分
func get_total_score():
	return total_score


## 是否结束
func is_game_over() -> bool:
	return _is_game_over


## 加分
func add_score():
	total_score += 1
	update_score_display()


## 更新得分显示
func update_score_display():
	pass


## 游戏结束
func set_game_over():
	_is_game_over = true
