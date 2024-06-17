extends CharacterBody2D
class_name PlayerBase # Player基类

@onready var animated_sprite_2d: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var run_dust_gpu_particles_2d: GPUParticles2D = $RunDustGPUParticles2D

var speed: float = 50.0
var move_vector: Vector2 = Vector2.ZERO


func _input(_event: InputEvent) -> void:
	if Input.get_vector("left", "right", "up", "down"):
		animated_sprite_2d.play("run")
		run_dust_gpu_particles_2d.emitting = true
	else :
		animated_sprite_2d.play("idle")
		run_dust_gpu_particles_2d.emitting = false


func _physics_process(_delta: float) -> void:
	move_vector = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = move_vector * speed
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false
	move_and_slide()
