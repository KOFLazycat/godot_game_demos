extends Node

func set_label_text(from: int, to: int, duration: float, method: Callable) -> void:
	var tween: Tween = create_tween()
	tween.tween_method(method, from, to, duration).set_trans(Tween.TRANS_LINEAR)
