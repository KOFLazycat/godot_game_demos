class_name DinoPlayer extends PlayerBase

@export var dino_jump_velocity_y: float = 600.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var default_gravity: float = ProjectSettings.get("physics/2d/default_gravity") as float


func _ready() -> void:
	animated_sprite_2d.play("run_normal")


func _physics_process(delta: float) -> void:
	velocity.y += default_gravity * delta
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		velocity.y = dino_jump_velocity_y * (-1)
