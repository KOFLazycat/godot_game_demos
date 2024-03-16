extends GPUParticles2D

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	# 定时器等待时间为粒子生命时间额外加1秒钟，保证粒子播放完毕
	timer.start(lifetime + 1.0)
	emitting = true


func on_timer_timeout() -> void:
	queue_free()
