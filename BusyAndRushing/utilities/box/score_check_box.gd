class_name ScoreCheckBox extends Area2D
# 用来校验得分的Box
var score: int = 0

signal check_body(score_body_box: ScoreBodyBox)


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(score_body_box: ScoreBodyBox) -> void:
	#print("[Hit] %s => %s", owner.name, score_body_box.owner.name)
	check_body.emit(score_body_box)
	score_body_box.score.emit(self, score)
