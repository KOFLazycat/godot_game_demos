class_name RunnerRock extends StaticBody2D

## 石头移动速度
@export var rock_speed: float = 150.0
## 每次越过石头获取金币
@export var gold: int = 10

@onready var score_check_box: ScoreCheckBox = $ScoreCheckBox


func _ready() -> void:
	score_check_box.score = gold


func _physics_process(delta: float) -> void:
	position.x -= rock_speed * delta
