extends Node2D

@onready var label: Label = $UI/PanelContainer/Label
@onready var timber_world: Node2D = $TimberWorld
@onready var runner_world: Node2D = $RunnerWorld
@onready var quiz_world: Node2D = $QuizWorld
@onready var tiny_defence_world: TinyDefenceWorld = $TinyDefenceWorld


func _ready() -> void:
	set_process(false)
	timber_world.timber_world_game_over.connect(on_game_over)
	runner_world.runner_world_game_over.connect(on_game_over)
	quiz_world.quiz_world_game_over.connect(on_game_over)
	tiny_defence_world.tiny_defence_world_game_over.connect(on_game_over)
	set_label_text(0, GameManager.get_game_score())
	set_process(true)


func _process(delta: float) -> void:
	label.text = str(GameManager.get_game_score())


func on_game_over() -> void:
	GameManager.set_game_over()


func set_label_text(from: int, to: int, duration: float = 1.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(update_label, from, to, duration).set_trans(Tween.TRANS_LINEAR)


func update_label(v: int) -> void:
	label.text = str(v)
