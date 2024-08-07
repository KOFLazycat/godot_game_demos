class_name Brick
extends StaticBody2D

@export var long_full: CompressedTexture2D = preload("res://src/main/assets/textures/brick/BlockLongFull.png")
@export var long_border: CompressedTexture2D = preload("res://src/main/assets/textures/brick/BlockLongBorder.png")
@export var small_full: CompressedTexture2D = preload("res://src/main/assets/textures/brick/BlockSmallFull.png")
@export var small_border: CompressedTexture2D = preload("res://src/main/assets/textures/brick/BlockSmallBorder.png")
@export var one: CompressedTexture2D = preload("res://src/main/assets/textures/brick/One.png")
@export var two: CompressedTexture2D = preload("res://src/main/assets/textures/brick/Two.png")
@export var three: CompressedTexture2D = preload("res://src/main/assets/textures/brick/Three.png")
@export var bomb: CompressedTexture2D = preload("res://src/main/assets/textures/brick/Bomb.png")
@export var energy: CompressedTexture2D = preload("res://src/main/assets/textures/brick/Energy.png")
@export var brick_explosion: PackedScene = preload("res://src/main/scene/role/brick/brick_explode_particles.tscn")
@export var bomb_explosion: PackedScene = preload("res://src/main/scene/role/brick/bomb_explode_particles.tscn")
@export var type: TYPE = TYPE.ONE
@export var size: SIZE = SIZE.SMALL

@onready var health: int = health_dict[type]
@onready var explosion_area: Area2D = $ExplosionArea
@onready var size_sprite: Sprite2D = $Size
@onready var type_sprite: Sprite2D = $Type
@onready var collision_shape_long: CollisionShape2D = $CollisionShapeLong
@onready var collision_shape_small: CollisionShape2D = $CollisionShapeSmall
@onready var animation_player: AnimationPlayer = $AnimationPlayer


enum TYPE {
	ONE,
	TWO,
	THREE,
	EXPLOSIVE,
	ENERGY
}

enum SIZE {
	SMALL,
	LONG
}

var health_dict = {
	TYPE.ONE: 1,       # 0.35
	TYPE.TWO: 2,       # 0.3
	TYPE.THREE: 3,	   # 0.20
	TYPE.EXPLOSIVE: 1, # 0.05
	TYPE.ENERGY: 1,    # 0.1
}
var _destroyed: bool = false
var bounce_tween: Tween

signal energy_brick_destroyed
signal destroyed(which: Brick)


func _ready() -> void:
	choose_type_random()
	choose_size_random()
	
	health = health_dict[type]
	
	update_size_visuals()
	update_type_visuals()
	
	animation_player.animation_finished.connect(on_animation_player_animation_finished)


func choose_type_random() -> void:
	var rand = randf()
	# 5% chance for explosives
	if rand < 0.05:
		type = TYPE.EXPLOSIVE
	elif rand >= 0.05 && rand < 0.15:
		type = TYPE.ENERGY
	elif rand >= 0.15 && rand < 0.35:
		type = TYPE.THREE
	elif rand >= 0.35 && rand < 0.65:
		type = TYPE.TWO
	else:
		type = TYPE.ONE
		
#	type = randi()%TYPE.size()


func choose_size_random() -> void:
	var rand = randf()
	if rand < 0.65:
		size = SIZE.LONG
	else:
		size = SIZE.SMALL


func update_size_visuals() -> void:
	match size:
		SIZE.SMALL:
			collision_shape_small.disabled = false
			collision_shape_long.disabled = true
			if type == TYPE.EXPLOSIVE or type == TYPE.ENERGY:
				size_sprite.texture = small_border
			else:
				size_sprite.texture = small_full
		SIZE.LONG:
			collision_shape_small.disabled = true
			collision_shape_long.disabled = false
			if type == TYPE.EXPLOSIVE or type == TYPE.ENERGY:
				size_sprite.texture = long_border
			else:
				size_sprite.texture = long_full


func update_type_visuals() -> void:
	match type:
		TYPE.ONE:
			type_sprite.texture = one
		TYPE.TWO:
			type_sprite.texture = two
		TYPE.THREE:
			type_sprite.texture = three
		TYPE.EXPLOSIVE:
			type_sprite.texture = bomb
		TYPE.ENERGY:
			type_sprite.texture = energy


func bounce() -> void:
	if is_instance_valid(bounce_tween) and bounce_tween.is_running():
		bounce_tween.kill()
	bounce_tween = create_tween()
	bounce_tween.tween_property(size_sprite, "scale", Vector2(1.15, 1.15), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	bounce_tween.parallel().tween_property(size_sprite, "rotation_degrees", randf_range(-10.0, 10.0), 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	# 恢复
	bounce_tween.tween_property(size_sprite, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	bounce_tween.parallel().tween_property(size_sprite, "rotation_degrees", 0.0, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

# 普通砖块爆炸粒子特效
func spawn_brick_explosion() -> void:
	var brick_explosion_instance: GPUParticles2D = brick_explosion.instantiate()
	get_tree().get_current_scene().add_child(brick_explosion_instance)
	brick_explosion_instance.global_position = global_position

# 炸弹砖块爆炸粒子特效
func spawn_bomb_explosion() -> void:
	var bomb_explosion_instance: GPUParticles2D = bomb_explosion.instantiate()
	get_tree().get_current_scene().add_child(bomb_explosion_instance)
	bomb_explosion_instance.global_position = global_position


func damage(value: int) -> void:
	health -= value
	
	if health <= 0:
		_destroyed = true
		match type:
			TYPE.EXPLOSIVE:
				explode()
			TYPE.ENERGY:
				give_energy()
		destroy()
	
	bounce()
	update_type_health()


func update_type_health() -> void:
	match health:
		3:
			type = TYPE.THREE
		2:
			type = TYPE.TWO
		1:
			type = TYPE.ONE
	update_type_visuals()


func give_energy() -> void:
	emit_signal("energy_brick_destroyed")


func explode() -> void:
	var bodies = explosion_area.get_overlapping_bodies()
	for body in bodies:
		if body._destroyed: continue
		# Damage with a high enough value to make sure
		# they're destroyed but also trigger any eventual
		# explosive bricks
		body.damage(10)


func destroy() -> void:
	if type == TYPE.EXPLOSIVE:
		spawn_bomb_explosion()
	else:
		spawn_brick_explosion()
	emit_signal("destroyed", self)
	queue_free()


func on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "appear":
		if type == TYPE.ENERGY or type == TYPE.EXPLOSIVE:
			animation_player.play("wiggle")
