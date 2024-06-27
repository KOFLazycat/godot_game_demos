extends CharacterBody2D
class_name PlayerBase # Player基类

@onready var body: Node2D = $Body
@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var run_dust_gpu_particles_2d: GPUParticles2D = $RunDustGPUParticles2D
@onready var dash_gpu_particles_2d: GPUParticles2D = $DashGPUParticles2D
@onready var dash_ghost_scene: PackedScene = preload("res://src/main/scene/role/player/dash_ghost/dash_ghost.tscn")
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_system: HurtSystem = $HurtSystem
@onready var input_manager: InputManager = InputManager.new()
@onready var state_chart: StateChart = $StateChart

# 加速度
var accel: float = 2000.0
# 玩家移动速度
var speed: float = 200.0
# dash移动速度
var dash_speed: float = 4000.0
# 朝向
var facing = Vector2.RIGHT :
	get: return facing
	set(value):
		if value == Vector2.ZERO: return
		facing = value
		animated_sprite_2d.flip_h = (value.x == -1)


func _ready() -> void:
	health_system.health = 100.0
	hurt_system.hurt.connect(_on_hurt_system_hurt)
	health_system.health_update.connect(_on_health_system_health_update)
	health_system.die.connect(_on_health_system_die)


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	input_manager.update(delta)
	pass


# dash的影子
func show_dash():
	var dash_ghost = dash_ghost_scene.instantiate()
	dash_ghost.texture = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame)
	dash_ghost.global_position = global_position
	dash_ghost.flip_h = animated_sprite_2d.flip_h
	get_tree().root.call_deferred("add_child",dash_ghost)


func player_die() -> void:
	set_process(false)
	set_process_input(false)
	animated_sprite_2d.play("die")
	#AudioSystem.play_sfx(AudioSystem.SFX_INDEX.BODY_HIT)
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_hurt_system_hurt(damage: float, knockback_amount: float, angle: Vector2) -> void:
	health_system.health -= damage


func _on_health_system_health_update(health: float, is_heal: bool) -> void:
	var v: float = health / health_system.max_health
	get_tree().get_first_node_in_group("player_health_bar").update_value(v)


func _on_health_system_die() -> void:
	player_die()


func _on_idle_state_entered() -> void:
	animated_sprite_2d.play("idle")
	run_dust_gpu_particles_2d.emitting = false


func _on_idle_state_physics_processing(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, accel * delta)
	move_and_slide()
	if input_manager.is_dash:
		state_chart.send_event("PlayerMoveStateToDash")
	else: 
		if input_manager.normalized != Vector2.ZERO:
			state_chart.send_event("PlayerMoveStateToRun")
		else: 
			pass


func _on_run_state_entered() -> void:
	animated_sprite_2d.play("run")
	#AudioSystem.play_sfx(AudioSystem.SFX_INDEX.RUN)
	run_dust_gpu_particles_2d.emitting = true


func _on_run_state_physics_processing(delta: float) -> void:
	velocity = velocity.move_toward(speed * input_manager.normalized, accel * delta)
	facing = input_manager.raw
	move_and_slide()
	if input_manager.is_dash:
		state_chart.send_event("PlayerMoveStateToDash")
	else: 
		if input_manager.raw == Vector2.ZERO:
			state_chart.send_event("PlayerMoveStateToIdle")
		else: 
			pass


func _on_dash_state_entered() -> void:
	input_manager.is_dash = true
	dash_gpu_particles_2d.emitting = true
	animated_sprite_2d.play("dash")
	AudioSystem.play_sfx(AudioSystem.SFX_INDEX.DASH)
	await get_tree().create_timer(0.2, true, false, true).timeout
	input_manager.is_dash = false
	dash_gpu_particles_2d.emitting = false


func _on_dash_state_physics_processing(delta: float) -> void:
	if input_manager.is_dash:
		velocity = velocity.move_toward(dash_speed * input_manager.normalized, accel * delta)
		facing = input_manager.raw
		show_dash()
	move_and_slide()
	
	if !input_manager.is_dash:
		if input_manager.raw == Vector2.ZERO:
			state_chart.send_event("PlayerMoveStateToIdle")
		elif input_manager.normalized != Vector2.ZERO:
			state_chart.send_event("PlayerMoveStateToRun")
