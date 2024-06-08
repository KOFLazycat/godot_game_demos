extends Node2D
class_name Line


# 判断一行是否已经满了
func is_line_full(max_count: int) -> bool:
	return max_count == get_child_count()
