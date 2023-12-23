extends Control

@onready var card: Control = $Card
@onready var label_title: Label = $Card/VBoxContainer/LabelTitle
@onready var button_play: Button = $Card/VBoxContainer/ButtonPlay
@onready var button_quit: Button = $Card/VBoxContainer/ButtonQuit
@onready var label_description: Label = $Card/VBoxContainer/LabelDescription

var tween: Tween


func _ready() -> void:
	Global.show_first_scene()
	card.scale = Vector2.ZERO
	label_title.self_modulate.a = 0.0
	button_play.self_modulate.a = 0.0
	button_quit.self_modulate.a = 0.0
	label_description.self_modulate.a = 0.0
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(1.5)
	tween.tween_property(card, "scale", Vector2.ONE, 0.75).from(Vector2.ZERO)
	
	tween.tween_property(label_title, "self_modulate:a", 1.0, 0.5)
	tween.tween_property(button_play, "self_modulate:a", 1.0, 0.8)
	tween.tween_property(button_quit, "self_modulate:a", 1.0, 0.8)
	tween.tween_property(label_description, "self_modulate:a", 1.0, 0.5)
	
	await tween.finished
	
	button_play.pressed.connect(on_button_play_pressed)
	button_quit.pressed.connect(on_button_quit_pressed)


func on_button_play_pressed() -> void:
	Global.change_scene("room")


func on_button_quit_pressed() -> void:
	get_tree().quit()
