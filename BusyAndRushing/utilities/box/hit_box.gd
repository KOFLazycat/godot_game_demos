class_name HitBox extends Area2D

var damage: float = 0.0

signal hit(hurt_box: HurtBox)


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(hurt_box: HurtBox) -> void:
	print("[Hit] %s => %s", owner.name, hurt_box.owner.name)
	hit.emit(hurt_box)
	hurt_box.hurt.emit(self, damage)
