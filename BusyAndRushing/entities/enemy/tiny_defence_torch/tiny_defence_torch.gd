class_name TinyDefenceTorch extends EnemyBase

@export var movement_speed: float = 20.0
@export var max_hp: float = 10.0
@export var knockback_recovery: float = 3.5

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var castle = get_tree().get_first_node_in_group("castle")
@onready var hurt_box: HurtBox = $HurtBox
@onready var juicy_bar: JucyBar = $JuicyBar

var knockback: Vector2 = Vector2.ZERO
var dead: bool = false
var hp: float = 0.0
const STOP_DISTANCE: float = 100.0


func _ready() -> void:
	hp = max_hp
	hurt_box.hurt.connect(on_hurt_box_hurt)


func _physics_process(delta: float) -> void:
	if !dead:
		if global_position.distance_to(castle.global_position) <= STOP_DISTANCE:
			velocity = Vector2.ZERO
			animated_sprite_2d.play("attack")
		else :
			knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
			var direction: Vector2 = global_position.direction_to(castle.global_position)
			velocity = direction * movement_speed
			velocity += knockback
			if velocity != Vector2.ZERO:
				animated_sprite_2d.play("walk")
	move_and_slide()
	
	if velocity.x > 0.1:
		animated_sprite_2d.flip_h = false
	elif velocity.x < -0.1:
		animated_sprite_2d.flip_h = true


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hp = clampf(hp - damage, 0.0, max_hp)
	var decrease_percent: float = damage / max_hp
	juicy_bar.decrease_current_value(decrease_percent)
	if hp == 0.0:
		dead = true
		velocity = Vector2.ZERO
		animated_sprite_2d.play("die")
		await animated_sprite_2d.animation_finished
		queue_free()
