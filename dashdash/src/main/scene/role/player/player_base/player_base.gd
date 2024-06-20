extends CharacterBody2D
class_name PlayerBase # Player基类

@onready var body: Node2D = $Body
@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var run_dust_gpu_particles_2d: GPUParticles2D = $RunDustGPUParticles2D
@onready var dash_gpu_particles_2d: GPUParticles2D = $DashGPUParticles2D
@onready var dash_ghost_scene: PackedScene = preload("res://src/main/scene/role/player/dash_ghost/dash_ghost.tscn")
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_system: HurtSystem = $HurtSystem


# 玩家移动速度
var speed: float = 50.0
# dash移动速度
var dash_speed: float = 1000.0
# 玩家移动方向
var move_vector: Vector2 = Vector2.ZERO
# 是否dash
var is_dash: bool = false


func _ready() -> void:
	health_system.health = 100.0
	hurt_system.hurt.connect(_on_hurt_system_hurt)
	health_system.die.connect(_on_health_system_die)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash") && !is_dash:
		is_dash = true
		dash_gpu_particles_2d.emitting = true
		animated_sprite_2d.play("dash")
		AudioSystem.play_sfx(AudioSystem.SFX_INDEX.DASH)
		await get_tree().create_timer(0.1).timeout
		is_dash = false
		dash_gpu_particles_2d.emitting = false
	elif Input.get_vector("left", "right", "up", "down"):
		animated_sprite_2d.play("run")
		#AudioSystem.play_sfx(AudioSystem.SFX_INDEX.RUN)
		run_dust_gpu_particles_2d.emitting = true
	else :
		animated_sprite_2d.play("idle")
		run_dust_gpu_particles_2d.emitting = false
		


func _physics_process(_delta: float) -> void:
	move_vector = Input.get_vector("left", "right", "up", "down").normalized()
	if move_vector.x < 0:
		animated_sprite_2d.flip_h = true
	elif move_vector.x > 0:
		animated_sprite_2d.flip_h = false
	
	if is_dash:
		velocity = move_vector * dash_speed
		show_dash()
	else:
		velocity = move_vector * speed
	move_and_slide()

# dash的影子
func show_dash():
	var dash_ghost = dash_ghost_scene.instantiate()
	dash_ghost.texture = animated_sprite_2d.sprite_frames.get_frame_texture(animated_sprite_2d.animation, animated_sprite_2d.frame)
	dash_ghost.global_position = global_position
	dash_ghost.flip_h = animated_sprite_2d.flip_h
	get_tree().root.call_deferred("add_child",dash_ghost)


func player_die() -> void:
	animated_sprite_2d.play("die")
	#AudioSystem.play_sfx(AudioSystem.SFX_INDEX.BODY_HIT)
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_hurt_system_hurt(damage: float, knockback_amount: float, angle: Vector2) -> void:
	health_system.health -= damage


func _on_health_system_die() -> void:
	player_die()
