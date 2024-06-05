extends Node
#Shape described by column:
# 数值代表颜色，排布是竖向排列，不为0的地方需要画纹理
const I_SHAPE: Array[Array] = [[0,1,0,0],[0,1,0,0],[0,1,0,0],[0,1,0,0]]
const J_SHAPE: Array[Array] = [[2,2,0],[0,2,0],[0,2,0]]
const L_SHAPE: Array[Array] = [[0,3,0],[0,3,0],[3,3,0]]
const O_SHAPE: Array[Array] = [[0,0,0,0],[0,4,4,0],[0,4,4,0],[0,0,0,0]]
const T_SHAPE: Array[Array] = [[0,5,0],[5,5,0],[0,5,0]]
const Z_SHAPE: Array[Array] = [[6,0,0],[6,6,0],[0,6,0]]
const S_SHAPE: Array[Array] = [[0,7,0],[7,7,0],[7,0,0]]

const SHAPES: Array = [I_SHAPE, J_SHAPE, L_SHAPE, O_SHAPE, T_SHAPE, Z_SHAPE, S_SHAPE]
const KICK_TABLE: Array[Array] = [[Vector2(0,0), Vector2(-1,0), Vector2(-1,-1), Vector2(0,2), Vector2(-1,2)], #0->1
						[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,-2), Vector2(1,-2)], #1->2
						[Vector2(0,0), Vector2(1,0), Vector2(1,-1), Vector2(0,2), Vector2(1,2)], #2->3
						[Vector2(0,0), Vector2(-1,0), Vector2(-1,1), Vector2(0,-2), Vector2(-1,-2)], #3->0
]
const KICK_TABLE_I: Array[Array] = [[Vector2(0,0), Vector2(-2,0), Vector2(1,0), Vector2(-2,1), Vector2(1,-2)], #0->1
						[Vector2(0,0), Vector2(-1,0), Vector2(2,0), Vector2(-1,-2), Vector2(2,1)], #1->2
						[Vector2(0,0), Vector2(2,0), Vector2(-1,0), Vector2(2,-1), Vector2(-1,2)], #2->3
						[Vector2(0,0), Vector2(1,0), Vector2(-2,0), Vector2(1,2), Vector2(-2,-1)], #3->0
]
