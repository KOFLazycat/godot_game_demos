extends Area2D
class_name HitBox # 对对方产生有效伤害的范围判定

signal hit(hurtbox)


func _init() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox: HurtBox) -> void:
	#print("[HIT] %s => %s" % [owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
