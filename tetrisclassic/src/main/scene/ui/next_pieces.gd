extends PiecePanel

const numberOfPieces: int = 5
const separation: float = 105

func drawPieces(currentBag: Array[Node2D], nextBag: Array[Node2D]):
	Utilities.delete_children(self)
	var fullQueue: Array[Node2D] = currentBag.duplicate()
	fullQueue.append_array(nextBag)
	for i in range(numberOfPieces):
		drawPiece(fullQueue[i], i * separation)
