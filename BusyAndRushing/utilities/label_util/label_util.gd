extends Node

var label: Label


func set_label(l: Label) -> void:
	label = l


func set_label_text(from: int, to: int, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(update_label, from, to, duration).set_trans(Tween.TRANS_LINEAR)


func update_label(v: int) -> void:
	label.text = str(v)
