class_name TimberWorld extends Node2D

## 每秒递减百分比
@export var decrease_percent: float = 0.01
## 递减时间间隔
@export var decrease_timer_interval: float = 1
## 每次按钮增加百分比
@export var increase_percent: float = 0.05

@onready var juicy_bar: JucyBar = $JuicyBar
@onready var trees: Trees = $Trees
@onready var timber: Timber = $Timber
@onready var chop_button: Button = $ChopButton
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var pcam: PhantomCamera2D = $PhantomCamera2D

signal timber_world_game_over


func _ready() -> void:
	decrease_timer.wait_time = decrease_timer_interval
	chop_button.pressed.connect(on_chop_button_pressed)
	decrease_timer.timeout.connect(on_decrease_timer_timeout)
	juicy_bar.empty.connect(on_juicy_bar_empty)
	chop_button.set_deferred("disabled", true)
	chop_button.set_deferred("visible", false)


func game_world_start() -> void:
	chop_button.set_deferred("disabled", false)
	chop_button.set_deferred("visible", true)
	decrease_timer.start()


func on_chop_button_pressed() -> void:
	chop_button.set_deferred("disabled", true)
	decrease_timer.stop()
	juicy_bar.increase_current_value(increase_percent)
	timber.choping()
	# 等待
	await get_tree().create_timer(0.5).timeout
	decrease_timer.start()
	chop_button.set_deferred("disabled", false)


func on_decrease_timer_timeout() -> void:
	juicy_bar.decrease_current_value(decrease_percent)


func on_juicy_bar_empty() -> void:
	timber_world_game_over.emit()
