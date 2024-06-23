extends State

# 进入状态
func enter() -> void:
	object.input_manager.is_dash = true
	object.dash_gpu_particles_2d.emitting = true
	object.animated_sprite_2d.play("dash")
	AudioSystem.play_sfx(AudioSystem.SFX_INDEX.DASH)
	await get_tree().create_timer(0.2, true, false, true).timeout
	object.input_manager.is_dash = false
	object.dash_gpu_particles_2d.emitting = false


# 帧更新
func update(delta: float) -> void:
	pass


# 物理帧更新
func physics_update(delta: float) -> void:
	if object.input_manager.is_dash:
		object.velocity = object.velocity.move_toward(object.dash_speed * object.input_manager.normalized, object.accel * delta)
		object.facing = object.input_manager.raw
		object.show_dash()
	object.move_and_slide()
	
	if !object.input_manager.is_dash:
		if object.input_manager.raw == Vector2.ZERO:
			change_state("player_idle_state")
		elif object.input_manager.normalized != Vector2.ZERO:
			change_state("player_run_state")


# 退出状态
func exit():
	pass


# 改变成另一个状态
func change_state(next_state: String) -> void:
	fsm.change_state(next_state)
