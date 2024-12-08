class_name TinyDefenceArcher extends PlayerBase

## 大招释放箭矢数量
@export var power_arrow_num: int = 10
## 大招间隔时间
@export var power_interval: float = 10.0
## 大招可释放时，觉得外边框颜色
@export var power_color: Color = Color.WHITE_SMOKE
## 塔
@export var tower: Tower
## 每次点击塔恢复血量
@export var hp_restore: float = 10.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_tscn: PackedScene = preload("res://entities/bullet/arrow/arrow.tscn") as PackedScene
@onready var state_chart: StateChart = $StateChart
@onready var button: Button = $Button
@onready var power_interval_timer: Timer = $PowerIntervalTimer

var animated_sprite_2d_flip_h: bool = false
var is_rage: bool = false
var current_arrow_num: int = 1


func _ready() -> void:
	power_interval_timer.wait_time = power_interval
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h
	animated_sprite_2d.material.set_shader_parameter("color", Color.WHITE_SMOKE)
	button.set_deferred("disabled", true)
	power_interval_timer.start()
	button.pressed.connect(on_button_pressed)
	power_interval_timer.timeout.connect(on_power_interval_timer_timeout)


func fire() -> void:
	for i in range(current_arrow_num):
		animated_sprite_2d.play("shot_tilt_up")
		await animated_sprite_2d.animation_finished
		var arrow: Arrow = arrow_tscn.instantiate()
		# 狂怒状态下攻击速度和伤害都会增加
		if current_arrow_num > 1:
			arrow.damage = arrow.damage * 5
		add_child(arrow)
	if is_rage:
		state_chart.send_event("to_rage")
	else:
		state_chart.send_event("to_idle")


func on_button_pressed() -> void:
	button.set_deferred("disabled", true)
	is_rage = true
	tower.restore_hp(hp_restore)


func on_power_interval_timer_timeout() -> void:
	button.set_deferred("disabled", false)
	animated_sprite_2d.material.set_shader_parameter("color", Color.CHARTREUSE)
	#power_interval_timer.stop()


func _on_idle_state_entered() -> void:
	current_arrow_num = 1
	state_chart.send_event("idle_to_attack")


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")


func _on_attck_state_entered() -> void:
	fire()


func _on_rage_state_entered() -> void:
	is_rage = false
	animated_sprite_2d.material.set_shader_parameter("color", Color.CRIMSON)
	current_arrow_num = power_arrow_num
	fire()


func _on_rage_state_exited() -> void:
	power_interval_timer.start()
	animated_sprite_2d.material.set_shader_parameter("color", Color.WHITE_SMOKE)
