extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
## 持续时间
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var target_pos: Vector2 = Vector2.ZERO
var speed: float = 300.0


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


func _physics_process(delta: float) -> void:
	if target_pos != Vector2.ZERO:
		global_position = global_position.move_toward(target_pos, delta * speed)


func die() -> void:
	visible = false
	animation_player.play("die")


func on_timer_timeout() -> void:
	die()


func on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
