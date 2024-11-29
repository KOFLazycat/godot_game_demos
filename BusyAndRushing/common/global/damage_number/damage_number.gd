extends Control

## 数字向上跳动像素数
@export var number_offset_y: int = 50
## 数字向上跳动持续时间
@export var number_move_up_duration: float = 0.25
## 数字落回持续时间
@export var number_move_down_duration: float = 0.5
## 数字缩小持续时间
@export var number_shrink_duration: float = 0.25
## 普通字体颜色
@export var number_color_normal: Color = "#FFF"
## 暴击字体颜色
@export var number_color_critical: Color = "#B22"
## 伤害为0（miss）时字体颜色
@export var number_color_zero: Color = "#FFF8"

@onready var round_font = preload("res://assets/fonts/Round9x13.ttf")

## 展示伤害数字
func display_number(value: int, position: Vector2, is_critical: bool = false, prefix: String = "") -> void:
	var number: Label = Label.new()
	number.global_position = position
	number.text = prefix + str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	number.label_settings.font = round_font
	
	var color: Color = number_color_normal
	if is_critical:
		color = number_color_critical
	if value == 0:
		color = number_color_zero
	number.label_settings.font_color = color
	number.label_settings.font_size = 24
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(number, "position:y", number.position.y - number_offset_y, number_move_up_duration).set_ease(Tween.EASE_OUT)
	tween.tween_property(number, "position:y", number.position.y, number_move_down_duration).set_ease(Tween.EASE_IN).set_delay(number_move_up_duration)
	tween.tween_property(number, "scale", Vector2.ZERO, number_shrink_duration).set_ease(Tween.EASE_IN).set_delay(number_move_down_duration)
	
	await tween.finished
	number.queue_free()
	
