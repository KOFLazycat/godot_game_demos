extends Node2D

@onready var ui: Control = $UI

const Piece = preload("res://src/main/script/piece.gd")
const gridWidth: int = 10
const gridHeight: int = 23
const vanishZone: int = 3
const spriteSize: int = 32
const BORDER_OFFSET: float = 10
var grid: Array[Array] = []
var gridOffsetX: float
var gridOffsetY: float

var currentBag
var nextBag

func _ready():
	gridOffsetX = $UI/Border.position.x + BORDER_OFFSET
	gridOffsetY = $UI/Border.position.y - (vanishZone - 1) * spriteSize
	grid = MatrixOperations.create2DMatrix(gridWidth, gridHeight, 0)
	
	currentBag = newBag()
	nextBag = newBag()


func newBag() -> Array:
	var bagIndexes: Array = [0,1,2,3,4,5,6]
	var newBagIndexes: Array = bagIndexes.duplicate()
	newBagIndexes.shuffle()
	var bag: Array = []
	while (!newBagIndexes.is_empty()):
		var piece = Piece.new()
		piece.shape = Constants.SHAPES[newBagIndexes.pop_back()]
		bag.append(piece)
	return bag
