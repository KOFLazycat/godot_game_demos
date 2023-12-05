extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D

@export var speed: int = 100
@export var acceleration: float = 5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var direction: Vector2 = get_movement_vector()
	accelerate_in_direction(direction)
	move_and_slide()
	
	if direction != Vector2.ZERO:
		if speed > 100:
			animation_player.play("run")
		else:
			animation_player.play("walk")
	else:
		animation_player.play("idle")
	
	var move_sign: int = sign(direction.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()


func accelerate_in_direction(direction: Vector2) -> void:
	var desired_velocity: Vector2 = direction * speed
	velocity = velocity.lerp(desired_velocity, 1.0 - exp(-acceleration * get_process_delta_time()))

