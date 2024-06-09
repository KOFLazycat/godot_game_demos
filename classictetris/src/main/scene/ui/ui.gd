extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var score_value_label: Label = $MarginContainer/VBScore/ScoreValueLabel
@onready var levels_value_label: Label = $MarginContainer/VBLevels/LevelsValueLabel

func _ready() -> void:
	score_value_label.text = "00000"
	levels_value_label.text = "1"


func add_next_tetromino(tetromino: Tetromino, spawn_position: Vector2) -> void:
	if tetromino:
		tetromino.scale = Vector2(0.5, 0.5)
		panel_container.add_child(tetromino)
		tetromino.set_position(spawn_position)


func update_score_value(clear_lines_count: int) -> void:
	# 当前分数
	var cur_score: int = LoadSaveSystem.load_score()
	# 最新分数
	var new_score: int = clear_lines_count * 10
	if new_score > cur_score:
		LoadSaveSystem.save_score(new_score)
		var tween: Tween = get_tree().create_tween()
		tween.tween_method(update_score_label, cur_score, new_score, 0.3)


# 更新分值
func update_score_label(new_v: int) -> void:
	score_value_label.text = StringUtil.int_to_string_with_length(new_v, 5)


# 更新等级
func update_level_value(clear_lines_count: int) -> void:
	# 当前等级
	var cur_level: int = LoadSaveSystem.load_level()
	# 最新等级
	var new_level: int = ceil(clear_lines_count / 10.0)
	if new_level > cur_level:
		LoadSaveSystem.save_level(new_level)
		levels_value_label.text = str(new_level)
