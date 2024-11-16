class_name DinoCactus extends StaticBody2D

@export var cactus_velocity_x: float = 200.0
@onready var sprite_2d: Sprite2D = $Sprite2D

var sprite_frames_max: int = 4


func _ready() -> void:
	sprite_2d.frame = randi_range(0, sprite_frames_max)


func _physics_process(delta: float) -> void:
	position.x -= cactus_velocity_x * delta
