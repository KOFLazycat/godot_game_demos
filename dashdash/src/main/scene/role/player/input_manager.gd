extends Node
class_name InputManager

var x: float
var y: float
var normalized: Vector2 = Vector2.RIGHT
var raw: Vector2 = Vector2.ZERO
var dash_timer: float = -1.0
var is_dash: bool:
	get:
		return dash_timer >= 0
	set(value):
		dash_timer = 0.2 if value else -1


func update(delta: float) -> void:
	# dash计时
	if dash_timer > 0:
		dash_timer -= delta
	
	x = Input.get_axis("left", "right")
	y = Input.get_axis("up", "down")
	raw = Vector2(x, y)
	normalized = raw.normalized()
	
	if Input.is_action_just_pressed("dash"):
		is_dash = true
