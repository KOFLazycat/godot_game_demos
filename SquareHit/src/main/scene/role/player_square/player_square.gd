extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var trail_2d: Line2D = $Visuals/Trail2D
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var axe_ability_controller: Node = $Abilities/AxeAbilityController
@onready var health_component: HealthComponent = $HealthComponent


## 基本移速
@export var base_speed: int = 1000
## 最小移速
@export var min_speed: int = 400
## 最大移速
@export var max_speed: int = 4000
## 每次加速BUF可提供的加速度
@export var speed_up: int = 100
## 攻击武器
@export var axe_ability_scene: PackedScene
## 移动速度
var speed: int:
	get:
		return speed
	set(value):
		if speed != value:
			speed = value

## 平滑起步加速度
const ACCELERATION: int = 200

## 移动方向
var direction: Vector2 = Vector2.ZERO
## 本次碰撞后的法线
var current_normal: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")
	speed = base_speed
	
	# 连接信号
	health_component.died.connect(on_health_component_died)
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	accelerate_in_direction()
	#move_and_slide()
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	#collision.get_collider().ball_bounce()
	#collision.get_position()
	if not collision:
		if velocity != Vector2.ZERO:
			# 改变朝向
			var move_sign: int = sign(direction.x)
			if move_sign != 0:
				visuals.scale.x = move_sign
				#animation_player.speed_scale = 2
			if direction.x > 0:
				animation_player.play("run_left")
			if direction.x < 0:
				animation_player.play("run_right")
			if direction.y > 0:
				animation_player.play("run_down")
			if direction.y < 0:
				animation_player.play("run_up")
		else:
			if !Global._is_game_over:
				animation_player.play("idle")
	else:
		if velocity != Vector2.ZERO:
			direction = Vector2.ZERO
			velocity = Vector2.ZERO
		var normal: Vector2 = collision.get_normal()
		if normal != Vector2.ZERO:
			current_normal = normal


func _input(event: InputEvent) -> void:
	# 停止之前不允许修改方向，通过碰撞法线，实现角色不走回头路
	if event.is_pressed() and direction == Vector2.ZERO:
		direction = Vector2(event.get_action_strength("move_right") - event.get_action_strength("move_left"), event.get_action_strength("move_down") - event.get_action_strength("move_up")).normalized()
		#if event.is_action_pressed("move_right"):
			#if current_normal != Vector2.RIGHT:
				#direction = Vector2.RIGHT
		#elif event.is_action_pressed("move_left"):
			#if current_normal != Vector2.LEFT:
				#direction = Vector2.LEFT
		#elif event.is_action_pressed("move_down"):
			#if current_normal != Vector2.DOWN:
				#direction = Vector2.DOWN
		#elif event.is_action_pressed("move_up"):
			#if current_normal != Vector2.UP:
				#direction = Vector2.UP


func accelerate_in_direction() -> void:
	if !Global._is_game_over:
		var desired_velocity: Vector2 = direction * speed
		#velocity = desired_velocity
		velocity = velocity.lerp(desired_velocity, 1.0 - exp(-ACCELERATION * get_process_delta_time()))
	else:
		velocity = Vector2.ZERO


func speed_up_once() -> void:
	speed = clamp(speed + speed_up, min_speed, max_speed)
	trail_2d.length = floor(speed/200)
	print(trail_2d.length)


func die() -> void:
	Global.set_game_over()
	velocity = Vector2.ZERO
	animation_player.play("die")


func on_health_component_died() -> void:
	die()


func on_animation_player_animation_finished(anim: StringName) -> void:
	if anim == "die":
		queue_free()





