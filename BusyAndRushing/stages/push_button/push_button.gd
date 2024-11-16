extends Node2D

## 每秒递减百分比
@export var decrease_percent: float = 0.1
## 每次按钮增加百分比
@export var increase_percent: float = 0.1

@onready var juicy_bar: JucyBar = $JuicyBar
@onready var refresh_button: Button = $RefreshButton
@onready var decrease_timer: Timer = $DecreaseTimer


func _ready() -> void:
	decrease_timer.timeout.connect(on_decrease_timer_timeout)
	refresh_button.pressed.connect(on_refresh_button_pressed)


func on_decrease_timer_timeout() -> void:
	juicy_bar.decrease_current_value(decrease_percent)


func on_refresh_button_pressed() -> void:
	decrease_timer.stop()
	juicy_bar.increase_current_value(increase_percent)
	decrease_timer.start()
