class_name RunnerWorld extends Node2D

@onready var jump_button: Button = $JumpButton
@onready var button_disable_timer: Timer = $ButtonDisableTimer
@onready var runner_player: RunnerPlayer = $RunnerPlayer
@onready var hurt_box: HurtBox = $HurtBox
@onready var barrel_spawner_tscn: PackedScene = preload("res://entities/spawner/barrel_spawner/barrel_spawner.tscn") as PackedScene

signal runner_world_game_over


func _ready() -> void:
	jump_button.pressed.connect(on_jump_button_pressed)
	button_disable_timer.timeout.connect(on_button_disable_timer_timeout)
	hurt_box.hurt.connect(on_hurt_box_hurt)
	runner_player.runner_player_die.connect(on_runner_player_runner_player_die)


func game_world_start() -> void:
	var barrel_spawner: BarrelSpawner = barrel_spawner_tscn.instantiate()
	add_child(barrel_spawner)


func on_jump_button_pressed() -> void:
	jump_button.set_deferred("disabled", true)
	runner_player.jump()
	button_disable_timer.start()


func on_button_disable_timer_timeout() -> void:
	jump_button.set_deferred("disabled", false)


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hit_box.owner.get_score()
	hit_box.owner.explode()


func on_runner_player_runner_player_die() -> void:
	runner_world_game_over.emit()
