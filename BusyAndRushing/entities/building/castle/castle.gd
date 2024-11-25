extends StaticBody2D

@export var max_hp: float = 100.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var marker_2d_left: Marker2D = $Sprite2D/Marker2DLeft
@onready var marker_2d_right: Marker2D = $Sprite2D/Marker2DRight
@onready var juicy_bar: JucyBar = $JuicyBar
@onready var hurt_box: HurtBox = $HurtBox

var hp: float = 0.0

func _ready() -> void:
	hp = max_hp
	hurt_box.hurt.connect(on_hurt_box_hurt)


func on_hurt_box_hurt(hit_box: HitBox, damage: float) -> void:
	hp = clampf(hp - damage, 0.0, max_hp)
	var decrease_percent: float = damage / max_hp
	juicy_bar.decrease_current_value(decrease_percent)
	if hp == 0.0:
		queue_free()
