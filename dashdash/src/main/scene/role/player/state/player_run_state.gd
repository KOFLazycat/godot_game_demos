extends State

# 进入状态
func enter() -> void:
	object.animated_sprite_2d.play("run")
	#AudioSystem.play_sfx(AudioSystem.SFX_INDEX.RUN)
	object.run_dust_gpu_particles_2d.emitting = true


# 帧更新
func update(delta: float) -> void:
	pass


# 物理帧更新
func physics_update(delta: float) -> void:
	object.velocity = object.velocity.move_toward(object.speed * object.input_manager.normalized, object.accel * delta)
	object.facing = object.input_manager.raw
	object.move_and_slide()
	if object.input_manager.is_dash:
		change_state("player_dash_state")
	else: 
		if object.input_manager.raw == Vector2.ZERO:
			change_state("player_idle_state")
		else: 
			pass


# 退出状态
func exit():
	pass


# 改变成另一个状态
func change_state(next_state: String) -> void:
	fsm.change_state(next_state)
