extends CharacterBody2D
class_name EnemyBase  # Enemy基类

@export var player: PlayerBase
@export var speed: float = 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var undead_shadow: Sprite2D = $UndeadShadow
@onready var timer: Timer = $Timer
@onready var hurt_system: HurtSystem = $HurtSystem
@onready var health_system: HealthSystem = $HealthSystem
@onready var health_bar: HealthBar = $HealthBar
@onready var floating_text_scene: PackedScene = preload("res://src/main/scene/ui/floating_text/floating_text.tscn")


func _ready() -> void:
	init_enemy()


func _physics_process(_delta: float) -> void:
	var direction: Vector2 = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	elif direction.x > 0:
		animated_sprite_2d.flip_h = false
	navigation_agent_2d.velocity = direction * speed


func init_enemy() -> void:
	# 生成动画
	animated_sprite_2d.play("create")
	await animated_sprite_2d.animation_finished
	timer.timeout.connect(_on_timer_timeout)
	#navigation_agent_2d.navigation_finished.connect(_on_navigation_agent_2d_navigation_finished)
	navigation_agent_2d.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	hurt_system.hurt.connect(_on_hurt_system_hurt)
	
	health_system.health_update.connect(_on_health_system_health_update)
	health_system.die.connect(_on_health_system_die)


func enemy_die() -> void:
	navigation_agent_2d.avoidance_enabled = false
	undead_shadow.visible = false
	health_bar.visible = false
	animated_sprite_2d.play("die")
	AudioSystem.play_sfx(AudioSystem.SFX_INDEX.BODY_HIT)
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		navigation_agent_2d.target_position = player.global_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("run")
	else :
		animated_sprite_2d.play("idle")


func _on_hurt_system_hurt(damage: float, knockback_amount: float, angle: Vector2) -> void:
	var damage_i: int = round(damage)
	# 伤害飘字
	if damage_i > 0:
		var floating_text_instance = floating_text_scene.instantiate()
		add_child(floating_text_instance)
		floating_text_instance.global_position = global_position + Vector2.UP * 8
		floating_text_instance.floating(str(damage_i))
	
	health_system.health -= damage


func _on_health_system_health_update(health: float, is_heal: bool) -> void:
	var v: float = health / health_system.max_health
	health_bar.update_value(v)


func _on_health_system_die() -> void:
	enemy_die()
