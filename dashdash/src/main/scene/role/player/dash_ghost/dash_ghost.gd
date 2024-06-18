extends Sprite2D


func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self,"modulate:a", 0.0, 0.3)
	tween.tween_callback(self.queue_free)
