extends Node

const GAME_RESOURCE_PATH: String = "user://game_resource.tres"


func save_score(s: int) -> void:
	var game_resource: GameResource = GameResource.new()
	game_resource.score = s
	ResourceSaver.save(game_resource, GAME_RESOURCE_PATH)


func load_score() -> int:
	if ResourceLoader.exists(GAME_RESOURCE_PATH, "GameResource"):
		var game_resource: GameResource = ResourceLoader.load(GAME_RESOURCE_PATH)
		return game_resource.score
	else:
		return 0
