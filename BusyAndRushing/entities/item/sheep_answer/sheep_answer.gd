extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var answer_label: Label = $AnswerLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var marker_2d: Marker2D = $Marker2D

var right_answer: String = ""
var label_text: String = ""
var score_per_quiz: int = 3

signal select_result(is_correct: bool)

func _ready() -> void:
	answer_label.text = label_text
	animation_player.play("idle")
	set_process_input(true)


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var click_position: Vector2 = to_local(event.position)
			var rect: Rect2 = sprite_2d.get_rect()
			
			if rect.has_point(click_position):
				if right_answer == label_text:
					sprite_2d.material.set_shader_parameter("width", 2.0)
					animation_player.play("jump")
					var is_critical: bool = false
					DamageNumber.display_number(score_per_quiz, marker_2d.global_position, is_critical, "+")
					select_result.emit(true)
					set_process_input(false)
				else:
					select_result.emit(false)
