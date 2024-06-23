extends Node
class_name State # 状态基类

var object: Node
var fsm: Fsm


# 进入状态
func enter() -> void:
	pass


# 帧更新
func update(delta: float) -> void:
	pass


# 物理帧更新
func physics_update(delta: float) -> void:
	pass


# 退出状态
func exit():
	pass


# 改变成另一个状态
func change_state(next_state: String) -> void:
	fsm.change_state(next_state)
