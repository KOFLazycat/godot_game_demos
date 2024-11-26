class_name TinyDefenceArcher extends PlayerBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker_2d_left: Marker2D = $AnimatedSprite2D/Marker2DLeft
@onready var marker_2d_right: Marker2D = $AnimatedSprite2D/Marker2DRight
@onready var arrow_tscn: PackedScene = preload("res://entities/bullet/arrow/arrow.tscn") as PackedScene
@onready var state_chart: StateChart = $StateChart

var animated_sprite_2d_flip_h: bool = false
var enemy_target_array: Array[EnemyBase] = []


func _ready() -> void:
	animated_sprite_2d.flip_h = animated_sprite_2d_flip_h


func fire() -> void:
	animated_sprite_2d.play("shot_tilt_up")
	await animated_sprite_2d.animation_finished
	var arrow: CharacterBody2D = arrow_tscn.instantiate() as CharacterBody2D
	if animated_sprite_2d_flip_h:
		# 反转，面朝左，打的是左边的敌人
		if GameData.enemy_target_left.size() > 0:
			arrow.target_enemy = GameData.enemy_target_left[0]
			arrow.position = marker_2d_left.position
			arrow.attack_side = 0
			add_child(arrow)
	else:
		# 不反转，面朝右，打的是右边的敌人
		if GameData.enemy_target_right.size() > 0:
			arrow.target_enemy = GameData.enemy_target_right[0]
			arrow.position = marker_2d_right.position
			arrow.attack_side = 1
			add_child(arrow)
	state_chart.send_event("attack_to_idle")


func _on_idle_state_entered() -> void:
	pass


func _on_idle_state_physics_processing(delta: float) -> void:
	animated_sprite_2d.play("idle")
	if animated_sprite_2d_flip_h:
		# 反转，面朝左，打的是左边的敌人
		if GameData.enemy_target_left.size() > 0:
			state_chart.send_event("idle_to_attack")
	else:
		# 不反转，面朝右，打的是右边的敌人
		if GameData.enemy_target_right.size() > 0:
			state_chart.send_event("idle_to_attack")


func _on_attck_state_entered() -> void:
	fire()
