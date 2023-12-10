extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_out_timer: Timer = $FadeOutTimer

var color_rect_size: Vector2 = Vector2(500, 20)

func _ready() -> void:
	color_rect.size = color_rect_size
	color_rect.position.y = - color_rect.size.y/2
	collision_shape_2d.disabled = true
	collision_shape_2d.shape.size = color_rect.size
	animation_player.play("fade_in")
	fade_out_timer.timeout.connect(on_timer_timeout)
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


func on_timer_timeout() -> void:
	animation_player.play("fade_out")


func on_animation_player_animation_finished(anim: StringName) -> void:
	if anim == "fade_out":
		queue_free()
