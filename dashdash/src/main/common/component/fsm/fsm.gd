extends Node
class_name Fsm # 有限状态机

# state名称和节点字典
var states: Dictionary = {}
# state节点
var current_state_node: State
# 当前状态名称
var current_state: String
# 上一个状态名称
var previous_state: String


# 初始化状态机
func _ready() -> void:
	# 获取状态机所属对象
	var object: Node = get_parent()
	# 获取所有状态节点与名称
	for child in get_children():
		if child is State:
			states[child.name.to_snake_case()] = child
			child.object = object
			child.fsm = self


# 帧更新
func update(delta: float) -> void:
	if not current_state_node: 
		return
	current_state_node.update(delta)


# 物理帧更新
func physics_update(delta: float) -> void:
	if not current_state_node: 
		return
	current_state_node.physics_update(delta)


# 改变成另一个状态
func change_state(next_state: String) -> void:
	# 如果当前状态节点不为空，先执行退出状态方法
	if current_state_node:
		current_state_node.exit()
	previous_state = current_state
	current_state = next_state
	current_state_node = states[current_state]
	current_state_node.enter()
