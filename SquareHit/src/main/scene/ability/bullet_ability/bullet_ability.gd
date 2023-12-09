extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var velocity_component: Node = $VelocityComponent
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_stop_move: bool = false
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


func _process(delta: float) -> void:
	if !is_stop_move:
		velocity_component.accelerate_to_player()
		velocity = velocity_component.velocity
	
	global_position = global_position + velocity * delta


func die() -> void:
	is_stop_move = true
	velocity = Vector2.ZERO
	animation_player.play("die")


func on_timer_timeout() -> void:
	die()


func on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
