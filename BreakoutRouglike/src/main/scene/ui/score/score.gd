extends Control

@onready var score: Label = $Score


func set_score(v: int) -> void:
	score.text = str(v)
