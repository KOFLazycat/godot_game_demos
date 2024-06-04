extends Node2D

const dasDelay = 8
const infinityValue = 15
const gridWidth: int = 10
const gridHeight: int = 23
const vanishZone: int = 3
const spriteSize: int = 32

const BORDER_OFFSET: float = 10
const Piece = preload("res://src/main/script/piece.gd")
const darkMaterial = preload("res://src/main/assets/shaders/DarkMaterial.tres")
#const DropParticle = preload("res://scn/DropParticle.tscn")
#const ClearParticle = preload("res://scn/ClearParticle.tscn")
#const HoldParticle = preload("res://scn/HoldParticle.tscn")

var grid: Array[Array] = []
var gridOffsetX: float
var gridOffsetY: float
var currentPiece: Piece

var timer = 0
var deltaSum = 0
var clearedLines = 0
var dasCounter = 0
var lines = 0
var level = 1
var score = 0
var actions = 0
var prevActions = 0
var speed = 1
var hasSwapped = false

var currentBag: Array[Node2D]
var nextBag: Array[Node2D]
enum Direction {CLOCKWISE, ANTICLOCKWISE}


# Called when the node enters the scene tree for the first time.
func _ready():
	gridOffsetX = $UI/Border.position.x + BORDER_OFFSET
	gridOffsetY = $UI/Border.position.y - (vanishZone - 1) * spriteSize
	grid = MatrixOperations.create2DMatrix(gridWidth, gridHeight, 0)
	
	currentBag = newBag()
	nextBag = newBag()
	spawnFromBag()
	# TODO: 可以删除？
	#$UI/NextPieces.drawPieces(currentBag, nextBag)
	
	drawGrid()
	drawDroppingPoint()

# 生成新的方块数组
func newBag() -> Array[Node2D]:
	var bagIndexes: Array = [0,1,2,3,4,5,6]
	var newBagIndexes = bagIndexes.duplicate()
	newBagIndexes.shuffle()
	var bag: Array[Node2D] = []
	while (!newBagIndexes.is_empty()):
		var piece = Piece.new()
		piece.shape = Constants.SHAPES[newBagIndexes.pop_back()]
		bag.append(piece)
	return bag


# 从数组中生成方块
func spawnFromBag() -> void:
	if (!currentBag):
		currentBag = nextBag.duplicate()
		nextBag = newBag()
	currentPiece = currentBag.pop_front()
	spawnPiece()
	$UI/NextPieces.drawPieces(currentBag, nextBag)


# 生成方块
func spawnPiece() -> void:
	var spawnIn: int = 1
	var startingX: int = floor((gridWidth - currentPiece.shape[0].size()) / 2.0)
	for i in range(currentPiece.shape.size()):
		if currentPiece.shape[i][2] != 0 && grid[startingX + i][3] != 0:
			spawnIn = 0
			break;
	currentPiece.positionInGrid = Vector2(startingX, spawnIn)
	currentPiece.rotationState = 0
	addPiece()


# 添加方块
func addPiece() -> void:
	for x in currentPiece.shape.size():
		for y in currentPiece.shape[0].size():
			if currentPiece.shape[x][y] != 0:
				# 初始化方块到网格中
				grid[currentPiece.positionInGrid.x + x][currentPiece.positionInGrid.y + y] = currentPiece.shape[x][y]


# 画出方格，没有方块的方格纹理索引为0，同时初始化第一个方块在顶部
func drawGrid() -> void:
	Utilities.delete_children(self)
	for x in range(gridWidth):
		for y in range(vanishZone - 1, gridHeight):
			var circle = Sprite2D.new()
			if (y == 2):
				circle.region_enabled = true
				circle.region_rect = Rect2(0, 6, 16, 10)
				circle.position = Vector2(x*spriteSize + gridOffsetX, y*spriteSize + gridOffsetY + 16)
			else:
				circle.position = Vector2(x*spriteSize + gridOffsetX, y*spriteSize + gridOffsetY)
			circle.texture = PokeballTextures.getTextureForColorIndex(grid[x][y])
			circle.scale = Vector2(2,2)
			circle.centered = false
			add_child(circle)


# 画下方 Ghost piece
func drawDroppingPoint():
	deletePieceFromGrid()
	var droppingY: int = int(currentPiece.positionInGrid.y)
	var foundDroppingLine: bool = false

	while (!foundDroppingLine):
		for i in range(0,currentPiece.shape.size()):
			for j in range(currentPiece.shape[0].size()-1, -1, -1):
				if currentPiece.shape[i][j] != 0:
					if droppingY + j + 1 >= gridHeight:
						foundDroppingLine = true
						droppingY -= 1
						break
					if (grid[currentPiece.positionInGrid.x + i][droppingY + j + 1] != 0):
						foundDroppingLine = true
						droppingY -= 1
						break
		droppingY += 1
	addPiece()
	
	#draw shape with outline
	if droppingY >= vanishZone:
		for x in currentPiece.shape.size():
			for y in currentPiece.shape[0].size():
				if (currentPiece.shape[x][y] != 0) && (grid[currentPiece.positionInGrid.x + x][droppingY + y] == 0):
					var circle = Sprite2D.new()
					circle.position = Vector2(currentPiece.positionInGrid.x*spriteSize + x*spriteSize + gridOffsetX,droppingY*spriteSize+y*spriteSize + gridOffsetY)
					circle.texture = currentPiece.getTextureForPiece()
					circle.material = darkMaterial
					circle.scale = Vector2(2,2)
					circle.centered = false
					add_child(circle)


# 删除初始化在网格中的方块
func deletePieceFromGrid() -> void:
	#Delete old position
	for x in currentPiece.shape.size():
		for y in currentPiece.shape[0].size():
			if currentPiece.shape[x][y] != 0:
				grid[x + currentPiece.positionInGrid.x][y + currentPiece.positionInGrid.y] = 0
