extends Node2D

## 每秒递减百分比
@export var decrease_percent: float = 0.01
## 递减时间间隔
@export var decrease_timer_interval: float = 1
## 每次按钮增加百分比
@export var increase_percent: float = 0.05
## 初始木头量
@export var init_wood_num: int = 100

@onready var juicy_bar: JucyBar = $JuicyBar
@onready var trees: Trees = $Trees
@onready var timber: Timber = $Timber
@onready var chop_button: Button = $ChopButton
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var save_data_timer: Timer = $SaveDataTimer
@onready var label: Label = $Ui/PanelContainer/HBoxContainer/Label

var current_wood_num: int = 0


func _ready() -> void:
	current_wood_num = LoadSaveSystem.load_wood_num()
	current_wood_num = clampi(current_wood_num, init_wood_num, current_wood_num)
	set_label_text(0, current_wood_num, 0.5)
	decrease_timer.wait_time = decrease_timer_interval
	chop_button.pressed.connect(on_chop_button_pressed)
	decrease_timer.timeout.connect(on_decrease_timer_timeout)
	save_data_timer.timeout.connect(on_save_data_timer_timeout)
	juicy_bar.empty.connect(on_juicy_bar_empty)
	decrease_timer.start()


func _physics_process(delta: float) -> void:
	if current_wood_num <= 0:
		GameManager.set_game_over()


func set_label_text(from: int, to: int, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(update_label, from, to, duration).set_trans(Tween.TRANS_LINEAR)


func update_label(v: int) -> void:
	label.text = str(v)


func on_chop_button_pressed() -> void:
	decrease_timer.stop()
	juicy_bar.increase_current_value(increase_percent)
	timber.choping()
	# 等待
	await get_tree().create_timer(0.5).timeout
	current_wood_num += timber.obtain_wood_num
	set_label_text(current_wood_num - timber.obtain_wood_num, current_wood_num, 0.5)
	decrease_timer.start()
	LoadSaveSystem.save_wood_num(current_wood_num)


func on_decrease_timer_timeout() -> void:
	juicy_bar.decrease_current_value(decrease_percent)


# 每隔一段时间保存一次数据
func on_save_data_timer_timeout() -> void:
	LoadSaveSystem.save_wood_num(current_wood_num)


func on_juicy_bar_empty() -> void:
	GameManager.set_game_over()
