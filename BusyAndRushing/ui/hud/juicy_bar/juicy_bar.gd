class_name JucyBar extends HudBase

@export var top_layer_bar: ProgressBar
@export var bottom_layer_bar: ProgressBar

@export var min_value: float
@export var max_value: float
@export var current_value: float
@export var top_layer_bar_time: float = 0.2
@export var top_layer_bar_delay: float = 0.0
@export var bottom_layer_bar_time: float = 0.2
@export var bottom_layer_bar_delay: float = 0.0

@onready var sub_button: Button = $SubButton
@onready var add_button: Button = $AddButton

signal empty


func _ready() -> void:
	current_value = max_value
	set_progress_bar_default_values(top_layer_bar)
	set_progress_bar_default_values(bottom_layer_bar)
	sub_button.pressed.connect(on_sub_button_pressed)
	add_button.pressed.connect(on_add_button_pressed)


func set_progress_bar_default_values(bar: ProgressBar) -> void:
	bar.min_value = min_value
	bar.max_value = max_value
	bar.value = current_value


## 减少数值
func decrease_current_value(value: float) -> void:
	current_value = clamp(current_value - value, min_value, max_value)
	run_juicy_tween(top_layer_bar, current_value, top_layer_bar_time, top_layer_bar_delay)
	run_juicy_tween(bottom_layer_bar, current_value, bottom_layer_bar_time, bottom_layer_bar_delay)
	
	# 如果值为零，则发出信号
	if current_value <= 0:
		empty.emit()


## 增加数值
func increase_current_value(value: float) -> void:
	current_value = clamp(current_value + value, min_value, max_value)
	# 注意,在增加数值时，上下Bar变化的time和delay就正好相反了
	run_juicy_tween(bottom_layer_bar, current_value, top_layer_bar_time, top_layer_bar_delay)
	run_juicy_tween(top_layer_bar, current_value, bottom_layer_bar_time, bottom_layer_bar_delay)


func run_juicy_tween(bar: ProgressBar, value: float, length: float, delay: float) -> void:
	var tween = create_tween()
	tween.tween_property(bar, "value", value, length).set_delay(delay).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)


func on_sub_button_pressed() -> void:
	decrease_current_value(0.1)


func on_add_button_pressed() -> void:
	increase_current_value(0.1)
