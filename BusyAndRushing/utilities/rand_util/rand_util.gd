extends Node


func _init() -> void:
	randomize()


func randi_range_with_exclude(from: int, to: int, exclude_arr: Array[int]) -> int:
	var ret: int = randi_range(from, to)
	while exclude_arr.find(ret) >= 0:
		ret = randi_range(from, to)
	return ret
