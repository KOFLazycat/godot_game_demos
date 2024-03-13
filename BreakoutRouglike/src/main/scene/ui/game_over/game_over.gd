extends Control

signal retry

@onready var retry_btn: Button = $VB/RetryBtn
@onready var quit_btn: Button = $VB/QuitBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	retry_btn.pressed.connect(on_retry_btn_pressed)
	quit_btn.pressed.connect(on_quit_btn_pressed)
	retry_btn.grab_focus()


func on_retry_btn_pressed() -> void:
	emit_signal("retry")
	queue_free()


func on_quit_btn_pressed() -> void:
	get_tree().quit()
