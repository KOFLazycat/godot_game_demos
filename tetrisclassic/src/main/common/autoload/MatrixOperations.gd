extends Node

func create2DMatrix(width: int, height: int, value: int = 0) -> Array[Array]:
	var retArray: Array[Array]= []
	for x in range(width):
		retArray.append([])
		retArray[x].resize(height)

		for y in range(height):
			retArray[x][y] = value
	return retArray

func invert2DMatrix(matrix):
	var newMatrix = MatrixOperations.create2DMatrix(matrix[0].size(), matrix.size(), 0)
	for i in matrix.size():
		for j in matrix[i].size():
			newMatrix[j][i] = matrix[i][j]
	return newMatrix
	
func swap2DMatrixColumns(matrix):
	var newMatrix = MatrixOperations.create2DMatrix(matrix.size(), matrix[0].size(), 0)
	for i in matrix.size():
		for j in matrix[i].size():
			newMatrix[i][j] = matrix[matrix.size() -1 - i][j]
	return newMatrix
	
func swap2DMatrixRows(matrix):
	var newMatrix = MatrixOperations.create2DMatrix(matrix.size(), matrix[0].size(), 0)
	for j in matrix[0].size():
		for i in matrix.size():
			newMatrix[i][j] = matrix[i][matrix.size() -1 - j]
	return newMatrix

func removeColumnsFromMatrix(matrix, columnIndexList):
	var retMatrix = []
	for i in range(matrix.size()):
		if !columnIndexList.has(i):
			retMatrix.append(matrix[i])
	matrix = retMatrix

func removeRowsFromMatrix(matrix, rowIndexList):
	for i in range(rowIndexList.size()-1,-1,-1):
		for j in range(matrix.size()):
			matrix[j].remove_at(rowIndexList[i])
