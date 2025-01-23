extends Node

const GAME_RESOURCE_PATH: String = "user://game_resource.tres"


func save_history_max(v: int) -> void:
	var game_resource: GameResource = GameResource.new()
	game_resource.history_max = v
	ResourceSaver.save(game_resource, GAME_RESOURCE_PATH)


func load_history_max() -> int:
	if ResourceLoader.exists(GAME_RESOURCE_PATH, "GameResource"):
		var game_resource: GameResource = ResourceLoader.load(GAME_RESOURCE_PATH)
		return game_resource.history_max
	else:
		return 0
