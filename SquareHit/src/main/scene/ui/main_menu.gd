extends Control

@export var scene: String
@export var fade_out_speed: float = 1.0
@export var fade_in_speed: float = 1.0
@export var fade_out_pattern: String = "fade"
@export var fade_in_pattern: String = "fade"
@export var fade_out_smoothness = 0.1 # (float, 0, 1)
@export var fade_in_smoothness = 0.1 # (float, 0, 1)
@export var fade_out_inverted: bool = false
@export var fade_in_inverted: bool = false
@export var color: Color = Color(0, 0, 0)
@export var timeout: float = 0.0
@export var clickable: bool = false
@export var add_to_back: bool = true

@onready var card: Control = $Card
@onready var label_title: Label = $Card/VBoxContainer/LabelTitle
@onready var button_play: Button = $Card/VBoxContainer/ButtonPlay
@onready var button_quit: Button = $Card/VBoxContainer/ButtonQuit
@onready var label_description: Label = $Card/VBoxContainer/LabelDescription

@onready var fade_out_options = SceneManager.create_options(fade_out_speed, fade_out_pattern, fade_out_smoothness, fade_out_inverted)
@onready var fade_in_options = SceneManager.create_options(fade_in_speed, fade_in_pattern, fade_in_smoothness, fade_in_inverted)
@onready var general_options = SceneManager.create_general_options(color, timeout, clickable, add_to_back)

var tween: Tween


func _ready() -> void:
	scene = "main_menu"
	var fade_in_first_scene_options = SceneManager.create_options(fade_in_speed, fade_in_pattern)
	var first_scene_general_options = SceneManager.create_general_options(color, 1, clickable, add_to_back)
	SceneManager.show_first_scene(fade_in_first_scene_options, first_scene_general_options)
	# code breaks if scene is not recognizable
	SceneManager.validate_scene(scene)
	# code breaks if pattern is not recognizable
	SceneManager.validate_pattern(fade_out_pattern)
	SceneManager.validate_pattern(fade_in_pattern)
	
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
	scene = "room"
	SceneManager.change_scene(scene, fade_out_options, fade_in_options, general_options)


func on_button_quit_pressed() -> void:
	get_tree().quit()
