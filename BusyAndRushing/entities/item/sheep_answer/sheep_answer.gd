extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var answer_label: Label = $AnswerLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var right_answer: String = ""
var label_text: String = ""

signal select_result(is_correct: bool)

func _ready() -> void:
	answer_label.text = label_text
	animation_player.play("idle")


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var click_position: Vector2 = to_local(event.position)
			var rect: Rect2 = sprite_2d.get_rect()
			
			if rect.has_point(click_position):
				if right_answer == label_text:
					sprite_2d.material.set_shader_parameter("width", 2.0)
					animation_player.play("jump")
					select_result.emit(true)
				else:
					select_result.emit(false)
