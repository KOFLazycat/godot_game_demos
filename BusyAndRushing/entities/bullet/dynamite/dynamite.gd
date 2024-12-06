class_name Dynamite extends CharacterBody2D

@export var damage: float = 5.0
@export var distance: float = 280.0
@export var fly_time: float = 1
@export var gravity: float = 500
## 箭矢偏移角度最小值
@export var random_angle_min: float = -0.3
## 箭矢偏移角度最大值
@export var random_angle_max: float = 0.3

@onready var hit_box: HitBox = $HitBox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	hit_box.damage = damage
	velocity = Vector2(distance / fly_time, -0.5 * gravity * fly_time).rotated(randf_range(random_angle_min, random_angle_max))
	hit_box.hit.connect(on_hit_box_hit)


func _physics_process(delta: float) -> void:
	rotation += delta * 10
	velocity.y += gravity * delta
	var collide:KinematicCollision2D = move_and_collide(velocity * delta)
	if collide:
		on_collision()


func on_collision() -> void:
	set_physics_process(false)
	animated_sprite_2d.play("explosion")
	await animated_sprite_2d.animation_finished
	queue_free()


func on_hit_box_hit(hurt_box: HurtBox) -> void:
	animated_sprite_2d.play("explosion")
	await animated_sprite_2d.animation_finished
	queue_free()
