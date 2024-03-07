extends Control

@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	progress_bar.value = 0.0

func set_energy(v: float) -> void:
	progress_bar.value = v
