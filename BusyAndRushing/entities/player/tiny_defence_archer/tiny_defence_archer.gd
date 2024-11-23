class_name TinyDefenceArcher extends PlayerBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_tscn: PackedScene = preload("res://entities/bullet/arrow/arrow.tscn") as PackedScene
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


func fire() -> void:
	animated_sprite_2d.play("shot_tilt_up")
	await animated_sprite_2d.animation_finished
	var arrow: CharacterBody2D = arrow_tscn.instantiate() as CharacterBody2D
	arrow.arrow_flip_h = animated_sprite_2d.flip_h
	if arrow.arrow_flip_h:
		arrow.position = Vector2(-40, -30)
	else:
		arrow.position = Vector2(40, -30)
	add_child(arrow)


func on_timer_timeout() -> void:
	fire()
