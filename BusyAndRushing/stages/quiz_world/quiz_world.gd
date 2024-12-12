class_name QuizWorld extends Node2D

## 每秒递减百分比
@export var decrease_percent: float = 0.05
## 刷新百分比
@export var increase_percent: float = 1.0
## 答对每道题得分
@export var score_per_quiz: int = 3

@onready var juicy_bar: JucyBar = $JuicyBar
@onready var question_label: Label = $QuestionLabel
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var marker_2d_left: Marker2D = $Marker2DLeft
@onready var marker_2d_right: Marker2D = $Marker2DRight
@onready var marker_2d_mid: Marker2D = $Marker2DMid
@onready var sheep_answer_tscn: PackedScene = preload("res://entities/item/sheep_answer/sheep_answer.tscn") as PackedScene
@onready var sheep_group: Node2D = $SheepGroup
@onready var pcam: PhantomCamera2D = $PhantomCamera2D

var num_a: int = 0
var num_b: int = 0
var num_result: int = 0

signal quiz_world_game_over


func _ready() -> void:
	decrease_timer.timeout.connect(on_decrease_timer_timeout)
	juicy_bar.empty.connect(on_juicy_bar_empty)


func game_world_start() -> void:
	generate_question()
	decrease_timer.start()


# 产生题目
func generate_question() -> void:
	while true:
		num_a = randi_range(10, 99)
		num_b = randi_range(10, 99)
		num_result = num_a + num_b
		if num_result < 100:
			break
	
	question_label.text = str(num_a) + " + " + str(num_b)
	# 确定正确答案应该放在哪个button，1对应a，2对应b，3对应c
	var sheep_answer_left: Node2D = sheep_answer_tscn.instantiate() as Node2D
	var sheep_answer_mid: Node2D = sheep_answer_tscn.instantiate() as Node2D
	var sheep_answer_right: Node2D = sheep_answer_tscn.instantiate() as Node2D
	sheep_answer_left.global_position = marker_2d_left.global_position
	sheep_answer_mid.global_position = marker_2d_mid.global_position
	sheep_answer_right.global_position = marker_2d_right.global_position
	sheep_answer_left.score_per_quiz = score_per_quiz
	sheep_answer_mid.score_per_quiz = score_per_quiz
	sheep_answer_right.score_per_quiz = score_per_quiz
	sheep_answer_left.right_answer = str(num_result)
	sheep_answer_mid.right_answer = str(num_result)
	sheep_answer_right.right_answer = str(num_result)
	sheep_answer_left.select_result.connect(on_sheep_answer_select_result)
	sheep_answer_mid.select_result.connect(on_sheep_answer_select_result)
	sheep_answer_right.select_result.connect(on_sheep_answer_select_result)
	var t1: int = RandUtil.randi_range_with_exclude(10, 99, [num_result])
	var t2: int = RandUtil.randi_range_with_exclude(10, 99, [num_result, t1])
	match randi_range(1, 3):
		1:
			sheep_answer_left.label_text = str(num_result)
			sheep_answer_mid.label_text = str(t1)
			sheep_answer_right.label_text = str(t2)
		2:
			sheep_answer_left.label_text = str(t1)
			sheep_answer_mid.label_text = str(num_result)
			sheep_answer_right.label_text = str(t2)
		3:
			sheep_answer_left.label_text = str(t1)
			sheep_answer_mid.label_text = str(t2)
			sheep_answer_right.label_text = str(num_result)
	sheep_group.add_child(sheep_answer_left)
	sheep_group.add_child(sheep_answer_mid)
	sheep_group.add_child(sheep_answer_right)


func clean_sheep() -> void:
	for i in sheep_group.get_children():
		i.queue_free()


func on_decrease_timer_timeout() -> void:
	juicy_bar.decrease_current_value(decrease_percent)


func on_juicy_bar_empty() -> void:
	quiz_world_game_over.emit()


func on_sheep_answer_select_result(is_correct: bool) -> void:
	if is_correct:
		await get_tree().create_timer(0.8).timeout
		decrease_timer.stop()
		juicy_bar.increase_current_value(increase_percent)
		GameManager.add_game_score(score_per_quiz)
		decrease_timer.start()
		clean_sheep()
		generate_question()
	else:
		quiz_world_game_over.emit()
