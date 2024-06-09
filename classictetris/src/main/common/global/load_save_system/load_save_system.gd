extends Node

# 文件保存地址
const LOAD_SAVE_RESOURCE_PATH: String = "user://load_save_resource.tres"
var is_load: bool = false


# 获取保持文件的实力
func get_instance() -> LoadSaveResource:
	var instance: LoadSaveResource = ResourceLoader.load(LOAD_SAVE_RESOURCE_PATH)
	if is_instance_valid(instance):
		return instance
	else :
		return LoadSaveResource.new()
	


# 保存分数
func save_score(score: int) -> void:
	var load_save_resource: LoadSaveResource = get_instance()
	load_save_resource.score = score
	ResourceSaver.save(load_save_resource, LOAD_SAVE_RESOURCE_PATH)


# 保存等级
func save_level(level: int) -> void:
	var load_save_resource: LoadSaveResource = get_instance()
	load_save_resource.level = level
	ResourceSaver.save(load_save_resource, LOAD_SAVE_RESOURCE_PATH)


# 读取分数
func load_score() -> int:
	var load_save_resource: LoadSaveResource = get_instance()
	return load_save_resource.score


# 读取等级
func load_level() -> int:
	var load_save_resource: LoadSaveResource = get_instance()
	return load_save_resource.level
