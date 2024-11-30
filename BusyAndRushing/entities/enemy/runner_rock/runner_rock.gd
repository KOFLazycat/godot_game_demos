class_name RunnerRock extends StaticBody2D

@export var rock_speed: float = 150.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	position.x -= rock_speed * delta
