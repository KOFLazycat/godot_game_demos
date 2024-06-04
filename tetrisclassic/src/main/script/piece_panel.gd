extends Control
class_name PiecePanel
 
const Piece = preload("res://src/main/script/piece.gd")
const spriteSize: float = 16


# 画方块
func drawPiece(piece: Piece, yOffset: float):
	var shapeWithoutBorders: Array[Array] = piece.getShapeWithoutBorders()
	var panelMidPoint: float = size.x/2.0
	# 方块长宽
	var pieceSize: Vector2 = Vector2(shapeWithoutBorders.size() * spriteSize, shapeWithoutBorders[0].size() * spriteSize)
	# 方块位置偏移
	var origin: Vector2 = Vector2(panelMidPoint - pieceSize.x/2.0, panelMidPoint - pieceSize.y/2.0 + yOffset)

	# [[2, 2], [0, 2], [0, 2]] 画出来的结果是
	# 2 0 0
	# 2 2 2
	# 其中 2 是纹理的索引号，不为0的地方画纹理
	for i in range(shapeWithoutBorders.size()):
		for j in range(shapeWithoutBorders[0].size()):
			if (shapeWithoutBorders[i][j] != 0):
				var circle = Sprite2D.new()
				circle.position = Vector2(origin.x + spriteSize*i ,origin.y + spriteSize*j)
				circle.centered = false
				circle.texture = piece.getTextureForPiece()
				add_child(circle)
