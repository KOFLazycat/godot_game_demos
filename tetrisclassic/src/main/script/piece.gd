extends Node2D

var positionInGrid: Vector2
var rotationState: int = 0
var shape: Array[Array]


# 获取方块颜色索引
func getColorIndex() -> int:
	for i in range(shape.size()):
		for j in range(shape[0].size()):
			if shape[i][j] != 0:
				return shape[i][j]
	return 0


# 删除值全部为0的行或者列
func getShapeWithoutBorders() -> Array[Array]:
	var newShape: Array[Array] = shape.duplicate(true)
	#Check and remove empty rows 移除空行
	var rowsToRemove: Array = []
	for i in range(shape[0].size()):
		var empty = true
		for j in range(shape.size()):
			if shape[j][i] != 0:
				empty = false
				break;
		if empty:
			rowsToRemove.append(i)
	MatrixOperations.removeRowsFromMatrix(newShape, rowsToRemove)
	
	#Check and remove empty columns 移除空列
	var columnsToRemove: Array = []
	for j in range(newShape.size()):
		var empty = true
		for i in range(newShape[0].size()):
			if newShape[j][i] != 0:
				empty = false
				break;
		if empty:
			columnsToRemove.append(j)
	MatrixOperations.removeColumnsFromMatrix(newShape, columnsToRemove)
	return newShape


# 获取对应纹理
func getTextureForPiece() -> Resource:
	return PokeballTextures.getTextureForColorIndex(getColorIndex())
