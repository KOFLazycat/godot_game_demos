extends GPUParticles2D

@onready var timer: Timer = $Timer


func _ready() -> void:
	emitting = true
	timer.timeout.connect(on_timer_timeout)
	# 确保粒子效果播放完毕 然后再删除
	timer.start(lifetime + 1.0)


func on_timer_timeout() -> void:
	queue_free()
