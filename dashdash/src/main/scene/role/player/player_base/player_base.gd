extends CharacterBody2D
class_name PlayerBase # Player基类

@onready var body: Node2D = $Body
@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var run_dust_gpu_particles_2d: GPUParticles2D = $RunDustGPUParticles2D
@onready var dash_gpu_particles_2d: GPUParticles2D = $DashGPUParticles2D
@onready var dash_ghost_scene: PackedScene = preload("res://src/main/scene/role/player/dash_ghost/dash_ghost.tscn")
@onready var health_system: HealthSystem = $HealthSystem
@onready var hurt_system: HurtSystem = $HurtSystem
@onready var fsm: Fsm = $Fsm
@onready var input_manager: InputManager = InputManager.new()

# 加速度
var accel: float = 1000.0
# 玩家移动速度
var speed: float = 50.0
# dash移动速度
var dash_speed: float = 1000.0
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
	fsm.change_state("player_idle_state")


func _process(delta: float) -> void:
	fsm.update(delta)


func _physics_process(delta: float) -> void:
	input_manager.update(delta)
	fsm.physics_update(delta)


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
