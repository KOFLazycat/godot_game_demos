extends CharacterBody2D
class_name EnemyBase  # Enemy基类

@export var player: PlayerBase
@export var speed: float = 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var undead_shadow: Sprite2D = $UndeadShadow
@onready var timer: Timer = $Timer
@onready var hurt_box: HurtBox = $Hurtbox

var is_dead: bool = false


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
	hurt_box.hurt.connect(_on_hurt_box_hurt)


func die() -> void:
	navigation_agent_2d.avoidance_enabled = false
	undead_shadow.visible = false
	animated_sprite_2d.play("die")
	AudioSystem.play_sfx(AudioSystem.SFX_INDEX.BODY_HIT)
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_timer_timeout() -> void:
	navigation_agent_2d.target_position = player.global_position



func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	if velocity != Vector2.ZERO:
		animated_sprite_2d.play("run")
	else :
		animated_sprite_2d.play("idle")


func _on_hurt_box_hurt(hitbox: HitBox) -> void:
	die()
