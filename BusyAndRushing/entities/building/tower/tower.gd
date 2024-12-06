class_name Tower extends StaticBody2D

## 最大血量
@export var max_hp: float = 100.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_box: HurtBox = $HurtBox
@onready var juicy_bar: JucyBar = $JuicyBar

var current_hp: float = 0.0

signal tower_die


func _ready() -> void:
	current_hp = max_hp
	hurt_box.hurt.connect(on_hurt_box_hurt)


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	current_hp = clampf(current_hp - damage, 0.0, max_hp)
	var decrease_percent: float = damage / max_hp
	juicy_bar.decrease_current_value(decrease_percent)
	var is_critical: bool = true
	DamageNumber.display_number(damage, sprite_2d.global_position, is_critical, "-")
	if current_hp == 0.0:
		tower_die.emit()
