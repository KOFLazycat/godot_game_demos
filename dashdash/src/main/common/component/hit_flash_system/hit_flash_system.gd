extends Node
class_name HitFlashSystem

@export var health_system: HealthSystem
@export var sprite: AnimatedSprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready() -> void:
	health_system.health_update.connect(_on_health_system_health_update)
	sprite.material = hit_flash_material


# 生命减少则闪白
func _on_health_system_health_update(health: float, is_heal: bool) -> void:
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
