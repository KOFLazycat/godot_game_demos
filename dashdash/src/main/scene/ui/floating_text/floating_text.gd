extends Control
class_name FloatingText

@onready var label: Label = $Label


# 向上飘字
func floating(text: String) -> void:
	label.text = text
	
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE * 0.8, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	# 飘玩自动删除
	tween.tween_callback(queue_free)
