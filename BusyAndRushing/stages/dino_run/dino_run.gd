extends Node2D

@export var ground_velocity_x: float = 200.0
@onready var cloud_parallax_layer: ParallaxLayer = $ParallaxBackground/CloudParallaxLayer
@onready var ground_parallax_layer: ParallaxLayer = $ParallaxBackground/GroundParallaxLayer
@onready var cactus_spawn_timer: Timer = $CactusSpawnTimer
@onready var cactus: Node = $Cactus
@onready var dino_player: DinoPlayer = $DinoPlayer
var dino_cactus_tscn: PackedScene = preload("res://entities/enemy/dino_cactus/dino_cactus.tscn")
var is_game_over: bool = false

func _ready() -> void:
	cactus_spawn_timer.wait_time = randf_range(5, 10)
	cactus_spawn_timer.timeout.connect(on_cactus_spawn_timer_timeout)
	cactus_spawn_timer.start()
	dino_player.dino_game_over.connect(on_dino_player_dino_game_over)


func _process(delta: float) -> void:
	if !is_game_over:
		cloud_parallax_layer.motion_offset.x -= delta * 80
		ground_parallax_layer.motion_offset.x -= delta * ground_velocity_x


func on_cactus_spawn_timer_timeout() -> void:
	# cactus产生数量随机
	var num: int = randi_range(1, 3)
	var cactus_pos_x: float = get_viewport_rect().size.x + randf_range(50, 300)
	for i in range(num):
		var dino_cactus: DinoCactus = dino_cactus_tscn.instantiate()
		dino_cactus.global_position = Vector2(cactus_pos_x + randi_range(20, 30)*i, 556.0)
		dino_cactus.scale = Vector2(randf_range(0.6, 1.0), randf_range(0.6, 1.0))
		cactus.add_child(dino_cactus)
	cactus_spawn_timer.wait_time = randf_range(5, 10)


func on_dino_player_dino_game_over() -> void:
	is_game_over = true
	get_tree().paused = true
