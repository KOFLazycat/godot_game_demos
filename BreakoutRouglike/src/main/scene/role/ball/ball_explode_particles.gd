extends GPUParticles2D

@onready var ball_explode_particles: GPUParticles2D = $"."
@onready var ball_explode_inside_particles: GPUParticles2D = $BallExplodeInsideParticles
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	# 确保粒子效果播放完毕 然后再删除
	timer.start(ball_explode_particles.lifetime + 1.0)
	ball_explode_particles.emitting = true
	ball_explode_inside_particles.emitting = true


func on_timer_timeout() -> void:
	queue_free()
