extends CharacterBody2D

@export var damage: float = 0.0
@export var distance: float = 150.0
@export var fly_time: float = 0.5
@export var gravity: float = 1000
## 箭矢偏移角度最小值
@export var random_angle_min: float = -0.2
## 箭矢偏移角度最大值
@export var random_angle_max: float = 0.2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox


var arrow_flip_h: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.damage = damage
	if arrow_flip_h:
		distance = distance * (-1)
	velocity = Vector2(distance / fly_time, -0.5 * gravity * fly_time).rotated(randf_range(random_angle_min, random_angle_max))
	rotation = velocity.angle()


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	rotation = velocity.angle()
	var collide:KinematicCollision2D = move_and_collide(velocity * delta)
	if collide:
		on_collision()


func on_collision() -> void:
	set_physics_process(false)
	var tween = create_tween()
	tween.tween_interval(randf_range(0.3, 0.7))
	tween.tween_property(self, "modulate:a", 0, 2.0)
	await  tween.finished
	queue_free()
