class_name Ball
extends CharacterBody2D

# 外部变量
@export var bump_timing_scene: PackedScene = preload("res://src/main/scene/role/bump_timings/bump_timings.tscn")
@export var bounce_particles_scene: PackedScene = preload("res://src/main/scene/role/ball/bounce_particles.tscn")
@export var bump_particles_scene: PackedScene = preload("res://src/main/scene/role/ball/bump_particles.tscn")
@export var explode_particles_scene: PackedScene = preload("res://src/main/scene/role/ball/ball_explode_particles.tscn")
@export var speed: float = 400.0
@export var accel: float = 20.0
@export var deccel: float = 3.0
@export var max_normal_angle: float = 15.0
@export var max_speed: float = 1200.0
@export var speed_threshold: float = 100.0
@export var steering_max_speed: float = 1200.0
@export var steer_force: float = 110.0
@export var steer_speed: float = 300.0
@export var max_speed_color: Color

# 就绪变量
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_base_scale: Vector2 = sprite.scale
@onready var trail_2d: Line2D = $Trail2D
@onready var speed_particles: GPUParticles2D = $SpeedParticles

# 普通变量
var acceleration: Vector2 = Vector2.ZERO
var attached_to = null
var hit_count: int = 0
var frame_count: int = 0
var no_collision_frame: int = 4
var attracted: bool = false
var attracted_to = null
var frames_since_paddle_collison: int = 0
var max_bump_distance: float = 40.0
var boost_factor_base: float = 1.15
var boost_factor: float = 1.0
var boost_factor_perfect: float = 1.3
var boost_factor_late_early: float = 1.15

# HitStop
var hitstop_frames: int = 0
var hitstop_bump_late_late_early: int = 5
var hitstop_bump_late_perfect: int = 10
var hitstop_paddle: int = 5
var hitstop_block: int = 5
var hitstop_bomb: int = 10

# 信号
signal hit_brick(brick: Brick)


func _ready() -> void:
	randomize()
	appear()


func _process(delta: float) -> void:
	color_based_on_velocity()
	scale_based_on_velocity()


func _physics_process(delta: float) -> void:
	if hitstop_frames > 0:
		hitstop_frames -= 1
		if hitstop_frames <= 0:
			stop_hitstop()
		return
	
	line_2d.rotation = velocity.angle()
	frames_since_paddle_collison += 1
	
	velocity = velocity.lerp(velocity.limit_length(speed), deccel * delta)
	
	if attached_to:
		global_position = attached_to.global_position
		return
		
	if attracted:
		var steer = Vector2.ZERO
		var desired = (attracted_to - position).normalized() * steer_speed
		steer = (desired - velocity).normalized() * steer_force
		acceleration += steer
		velocity += acceleration * delta
		velocity = velocity.limit_length(steering_max_speed)
#		rotation = velocity.angle()
	
	# Reset every frame to make sure we only attract
	# when pressing the button
	attracted = false
	var velocity_before_collision = velocity
	var collision = move_and_collide(velocity * delta)
	# 未碰撞直接返回
	if not collision: 
		return
	Globals.stats["ball_bounces"] += 1
	
	var normal = collision.get_normal()
	sprite.rotation = -normal.angle()
	animation_player.play("bounce")
	# Update the normal with the paddle's velocity if we collide with
	# the paddle
	if collision.get_collider().is_in_group("Paddle"):
		collision.get_collider().ball_bounce()
		frames_since_paddle_collison = 0
		Globals.camera.shake(0.3, 20, 20)
#		print("Normal:", normal)
#		print("Dot:", normal.dot(Vector2.UP))
		spawn_bump_particles(collision.get_position(), normal)
		# no bump boost == small hitstop
		if boost_factor == 1.0:
			start_hitstop(hitstop_paddle)
		
		# Collision from the top, most of the cases
		if normal.dot(Vector2.UP) > 0.0:
#			print("HIT TOP: ", Globals.stats["ball_bounces"])
			
			# Paddle is moving
			if collision.get_collider().velocity.length() > 0:
				# 碰撞前小球速度，碰撞只会改变速度方向，不会改变速度大小
				var length_before_collison = velocity.length()
				
				velocity.y = -velocity.y
				velocity.x += collision.get_collider().velocity.x * 0.6
				velocity = velocity.normalized()
				velocity *= length_before_collison
				velocity *= (boost_factor + boost_factor_base)
			else:
				## Tilt the normal near the edge
				# Calculate the distance between the collision point and the center of the paddle
				var distance = collision.get_position() - collision.get_collider().global_position
				var amount = distance.x/96.0
				#print(collision.get_position(), collision.get_collider().global_position)
				normal = normal.rotated(deg_to_rad(max_normal_angle)*amount)
				velocity = velocity.bounce(normal)*(boost_factor + boost_factor_base)
		else:
#			print("HIT SIDE: ", Globals.stats["ball_bounces"])
			# Check if below half of the thickness
			if collision.get_position().y > collision.get_collider().global_position.y:
#				print("BELOW HALF")
				velocity = velocity.bounce(normal)*(boost_factor + boost_factor_base)
			else:
				# Lateral normal respecting the sign checked the collision
				normal = Vector2(sign(normal.x), 0)
				# Rotate the normal upward
				var normal_rotated = normal.rotated(-sign(normal.x)*deg_to_rad(20.0))
				
				# Create the new velocity using the velocity length and the normal direction
				velocity = normal_rotated * velocity.length()
				velocity *= (boost_factor + boost_factor_base)
		# Reset bump boost
		boost_factor = 1.0
	elif collision.get_collider().is_in_group("Bricks"):
		if collision.get_collider().type == collision.get_collider().TYPE.ENERGY or \
			collision.get_collider().type == collision.get_collider().TYPE.EXPLOSIVE:
			Globals.camera.shake(1.0, 25, 30)
			velocity = velocity_before_collision
			start_hitstop(hitstop_bomb)
		else:
			Globals.camera.shake(0.25, 20, 20)
			velocity = velocity.bounce(normal)
			start_hitstop(hitstop_block)
		
		collision.get_collider().damage(1)
		emit_signal("hit_brick", collision.get_collider())
	else:
		Globals.camera.shake(0.15, 20, 10)
#		print("HIT OTHER: ", Globals.stats["ball_bounces"])
		spawn_bounce_particles(collision.get_position(), normal)
		velocity = velocity.bounce(normal)
	
	velocity = velocity.limit_length(max_speed)


## VISUALS ###
# 小球出现动画
func appear() -> void:
	# 防止粒子特效无法播放成功，先初始化
	animation_player.play("RESET")
	animation_player.play("appear")


func die() -> void:
	Globals.camera.shake(0.45, 30, 40)
	spawn_explode_particles(global_position)


func scale_based_on_velocity() -> void:
	if animation_player.is_playing():
		return
	sprite.scale = sprite_base_scale.lerp(sprite_base_scale * Vector2(1.4, 0.5), velocity.length()/max_speed)
	sprite.rotation = velocity.angle()


func color_based_on_velocity() -> void:
	var val = remap(velocity.length(), speed, max_speed, 0, 1.0)
	sprite.self_modulate = Color.WHITE.lerp(max_speed_color, val)
	trail_2d.self_modulate = sprite.self_modulate
	speed_particles.self_modulate = sprite.self_modulate
	if velocity.length() > speed + speed_threshold and not speed_particles.emitting:
		speed_particles.emitting = true
	else:
		speed_particles.emitting = false


func spawn_bounce_particles(pos: Vector2, normal: Vector2) -> void:
	var bounce_particles_instance: GPUParticles2D = bounce_particles_scene.instantiate()
	get_tree().get_current_scene().add_child(bounce_particles_instance)
	bounce_particles_instance.global_position = pos
	bounce_particles_instance.rotation = normal.angle()


func spawn_bump_particles(pos: Vector2, normal: Vector2) -> void:
	var bump_particles_instance: GPUParticles2D = bump_particles_scene.instantiate()
	get_tree().get_current_scene().add_child(bump_particles_instance)
	bump_particles_instance.global_position = pos
	bump_particles_instance.rotation = normal.angle()


func spawn_explode_particles(pos: Vector2) -> void:
	var explode_particles_instance: GPUParticles2D = explode_particles_scene.instantiate()
	get_tree().get_current_scene().add_child(explode_particles_instance)
	explode_particles_instance.global_position = pos


# 启动hitstop
func start_hitstop(hitstop_amount: int) -> void:
	animation_player.pause()
	hitstop_frames = hitstop_amount

# 停止hitstop
func stop_hitstop() -> void:
	animation_player.play()
	hitstop_frames = 0


func attract(global_position) -> void:
	attracted = true
	attracted_to = global_position


func spawn_bump_timing(type) -> void:
	var instance = bump_timing_scene.instantiate()
	instance.type = type
	get_parent().add_child(instance)
	instance.global_position = global_position


func bump_boost(who) -> void:
	var distance = who.global_position.distance_to(global_position)
	var contact_distance = distance - collision_shape_2d.shape.radius - (who.thickness / 2.0)
	
	# If we're too far, we don't bump
	if contact_distance > max_bump_distance: 
		print("BUMP TOO FAR")
		boost_factor = 1.0
		spawn_bump_timing(Globals.BUMP.TOO_FAR)
		return
	
	# We had a collision recently and we're now boosting: LATE
	if frames_since_paddle_collison > 5 and frames_since_paddle_collison < 20:
		print("BUMP LATE")
		boost_factor = boost_factor_late_early
		Globals.stats["bumps_late"] += 1
		spawn_bump_timing(Globals.BUMP.LATE)
	
	# Bump perfect
	elif frames_since_paddle_collison < 5:
		print("BUMP PERFECT")
		boost_factor = boost_factor_perfect
		Globals.stats["bumps_perfect"] += 1
		spawn_bump_timing(Globals.BUMP.PERFECT)
	
	# Bump early
	else:
		print("BUMP EARLY")
		boost_factor = boost_factor_late_early
		Globals.stats["bumps_early"] += 1
		spawn_bump_timing(Globals.BUMP.EARLY)


func launch() -> void:
#	velocity = (-global_transform.y).rotated(randf_range(-PI/3.0, PI/3.0)) * speed
	velocity = -global_transform.y * speed
	attached_to = null
