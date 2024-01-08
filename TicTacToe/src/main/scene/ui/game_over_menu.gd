extends Control

@onready var game_over_panel: Panel = $GameOverPanel
@onready var result_label: Label = $GameOverPanel/VBoxContainer/ResultLabel
@onready var restart_button: Button = $GameOverPanel/VBoxContainer/RestartButton

var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_panel.scale = Vector2.ZERO
	result_label.self_modulate.a = 0.0
	restart_button.self_modulate.a = 0.0
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.2)
	tween.tween_property(game_over_panel, "scale", Vector2.ONE, 0.75).from(Vector2.ZERO)
	tween.tween_property(result_label, "self_modulate:a", 1.0, 0.5)
	tween.tween_property(restart_button, "self_modulate:a", 1.0, 0.8)
	await tween.finished
	
	restart_button.pressed.connect(on_restart_button_pressed)


func on_restart_button_pressed() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.2)
	tween.tween_property(restart_button, "self_modulate:a", 0.0, 0.8)
	tween.tween_property(result_label, "self_modulate:a", 0.0, 0.5)
	tween.tween_property(game_over_panel, "scale", Vector2.ZERO, 0.75).from(Vector2.ONE)
	await tween.finished
	get_tree().change_scene_to_file("res://src/main/scene/level/main.tscn")
