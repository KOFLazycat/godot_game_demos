extends Node

const GAME_RESOURCE_PATH: String = "user://game_resource.tres"

var is_load: bool = false


func save_wood_num(wood_num: int) -> void:
	var game_resource: GameResource = GameResource.new()
	game_resource.wood_num = wood_num
	ResourceSaver.save(game_resource, GAME_RESOURCE_PATH)


func load_wood_num() -> int:
	if ResourceLoader.exists(GAME_RESOURCE_PATH, "GameResource"):
		var game_resource: GameResource = ResourceLoader.load(GAME_RESOURCE_PATH)
		return game_resource.wood_num
	else:
		return 0
