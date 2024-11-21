extends Node2D

## 每秒递减百分比
@export var decrease_percent: float = 0.1
## 刷新百分比
@export var increase_percent: float = 1.0

@onready var decrease_timer: Timer = $DecreaseTimer
@onready var juicy_bar: JucyBar = $CanvasLayer/PanelContainer/VBoxContainer/JuicyBar
@onready var topic_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/TopicLabel
@onready var option_a_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/OptionAButton
@onready var option_b_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/OptionBButton
@onready var option_c_button: Button = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/OptionCButton

var num_a: int = 0
var num_b: int = 0
var num_result: int = 0


func _ready() -> void:
	generate_topic()
	decrease_timer.timeout.connect(on_decrease_timer_timeout)
	option_a_button.pressed.connect(on_option_a_button_pressed)
	option_b_button.pressed.connect(on_option_b_button_pressed)
	option_c_button.pressed.connect(on_option_c_button_pressed)
	juicy_bar.empty.connect(on_juicy_bar_empty)


# 产生题目
func generate_topic() -> void:
	while true:
		num_a = randi_range(10, 99)
		num_b = randi_range(10, 99)
		num_result = num_a + num_b
		if num_result < 100:
			break
	
	topic_label.text = str(num_a) + " + " + str(num_b)
	# 确定正确答案应该放在哪个button，1对应a，2对应b，3对应c
	match randi_range(1, 3):
		1:
			option_a_button.text = str(num_result)
			option_b_button.text = str(num_result + 1)
			option_c_button.text = str(num_result + 2)
		2:
			option_a_button.text = str(num_result - 1)
			option_b_button.text = str(num_result)
			option_c_button.text = str(num_result + 1)
		3:
			option_a_button.text = str(num_result - 2)
			option_b_button.text = str(num_result - 1)
			option_c_button.text = str(num_result)


func check_result(button_num: String) -> void:
	if button_num == str(num_result):
		decrease_timer.stop()
		juicy_bar.increase_current_value(increase_percent)
		decrease_timer.start()
		generate_topic()
	else:
		print("Die.")


func on_decrease_timer_timeout() -> void:
	juicy_bar.decrease_current_value(decrease_percent)


func on_option_a_button_pressed() -> void:
	check_result(option_a_button.text)


func on_option_b_button_pressed() -> void:
	check_result(option_b_button.text)


func on_option_c_button_pressed() -> void:
	check_result(option_c_button.text)


func on_juicy_bar_empty() -> void:
	print("Bar Empty")
