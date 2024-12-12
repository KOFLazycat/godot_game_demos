extends Node2D

@onready var label: Label = $UI/PanelContainer/Label
@onready var runner_world_timer: Timer = $RunnerWorldTimer
@onready var quiz_world_timer: Timer = $QuizWorldTimer
@onready var tiny_defence_world_timer: Timer = $TinyDefenceWorldTimer
@onready var timber_world_fade_transition: FadeTransition = $UI/TimberWorldFadeTransition
@onready var runner_world_fade_transition: FadeTransition = $UI/RunnerWorldFadeTransition
@onready var quiz_world_fade_transition: FadeTransition = $UI/QuizWorldFadeTransition
@onready var tiny_defence_world_fade_transition: FadeTransition = $UI/TinyDefenceWorldFadeTransition
@onready var panel_container_2: PanelContainer = $UI/PanelContainer2
@onready var game_begin_button: Button = $UI/PanelContainer2/VBoxContainer/GameBeginButton
@onready var game_exit_button: Button = $UI/PanelContainer2/VBoxContainer/GameExitButton
@onready var timber_world_tscn: PackedScene = preload("res://stages/timber_world/timber_world.tscn") as PackedScene
@onready var runner_world_tscn: PackedScene = preload("res://stages/runner_world/runner_world.tscn") as PackedScene
@onready var quiz_world_tscn: PackedScene = preload("res://stages/quiz_world/quiz_world.tscn") as PackedScene
@onready var tiny_defence_world_tscn: PackedScene = preload("res://stages/tiny_defence_world/tiny_defence_world.tscn") as PackedScene
@onready var pcam: PhantomCamera2D = $PhantomCamera2D


func _ready() -> void:
	pcam.set_priority(10)
	AudioMasterAutoload.PlayBGM("res://assets/sounds/bg/Rhythmic Vol2 Chankura Main.ogg")
	# 遮罩
	timber_world_fade_transition.cover()
	runner_world_fade_transition.cover()
	quiz_world_fade_transition.cover()
	tiny_defence_world_fade_transition.cover()
	# 信号绑定
	runner_world_timer.timeout.connect(on_runner_world_timer_timeout)
	quiz_world_timer.timeout.connect(on_quiz_world_timer_timeout)
	tiny_defence_world_timer.timeout.connect(on_tiny_defence_world_timer_timeout)
	game_begin_button.pressed.connect(on_game_begin_button_pressed)
	game_exit_button.pressed.connect(on_game_exit_button_pressed)
	


func _process(delta: float) -> void:
	label.text = str(GameManager.get_game_score())


func init_timber_world() -> void:
	var timber_world: TimberWorld = timber_world_tscn.instantiate()
	add_child(timber_world)
	timber_world.timber_world_game_over.connect(on_game_over)
	timber_world.game_world_start()
	timber_world.pcam.set_priority(20)
	timber_world_fade_transition.uncover()


func init_runner_world() -> void:
	var runner_world: RunnerWorld = runner_world_tscn.instantiate()
	add_child(runner_world)
	runner_world.runner_world_game_over.connect(on_game_over)
	runner_world.game_world_start()
	runner_world.pcam.set_priority(20)
	runner_world_fade_transition.uncover()


func init_quiz_world() -> void:
	var quiz_world: QuizWorld = quiz_world_tscn.instantiate()
	add_child(quiz_world)
	quiz_world.quiz_world_game_over.connect(on_game_over)
	quiz_world.game_world_start()
	quiz_world.pcam.set_priority(20)
	quiz_world_fade_transition.uncover()


func init_tiny_defence_world() -> void:
	var tiny_defence_world: TinyDefenceWorld = tiny_defence_world_tscn.instantiate()
	add_child(tiny_defence_world)
	tiny_defence_world.tiny_defence_world_game_over.connect(on_game_over)
	tiny_defence_world.game_world_start()
	tiny_defence_world_fade_transition.uncover()


func on_game_over() -> void:
	GameManager.set_game_over()


func set_label_text(from: int, to: int, duration: float = 1.0) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(update_label, from, to, duration).set_trans(Tween.TRANS_LINEAR)


func update_label(v: int) -> void:
	label.text = str(v)


func on_runner_world_timer_timeout() -> void:
	init_runner_world()


func on_quiz_world_timer_timeout() -> void:
	init_quiz_world()


func on_tiny_defence_world_timer_timeout() -> void:
	init_tiny_defence_world()


func on_game_begin_button_pressed() -> void:
	panel_container_2.set_deferred("visible", false)
	runner_world_timer.start()
	quiz_world_timer.start()
	tiny_defence_world_timer.start()
	init_timber_world()


func on_game_exit_button_pressed() -> void:
	get_tree().quit()
