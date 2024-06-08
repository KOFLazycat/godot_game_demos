extends Area2D
class_name  Piece

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# 设置纹理
func set_texture(texture: Texture2D):
	sprite_2d.texture = texture


# 获取碰撞大小
func get_size():
	return collision_shape_2d.shape.get_rect().size
