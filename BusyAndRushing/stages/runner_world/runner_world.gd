extends Node2D

@onready var jump_button: Button = $JumpButton
@onready var button_disable_timer: Timer = $ButtonDisableTimer
@onready var runner_player: RunnerPlayer = $RunnerPlayer
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	jump_button.pressed.connect(on_jump_button_pressed)
	button_disable_timer.timeout.connect(on_button_disable_timer_timeout)
	hurt_box.hurt.connect(on_hurt_box_hurt)


func on_jump_button_pressed() -> void:
	jump_button.set_deferred("disabled", true)
	runner_player.jump()
	button_disable_timer.start()


func on_button_disable_timer_timeout() -> void:
	jump_button.set_deferred("disabled", false)


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hit_box.owner.get_score()
	hit_box.owner.explode()
