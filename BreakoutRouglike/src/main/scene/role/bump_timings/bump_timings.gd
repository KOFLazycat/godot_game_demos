class_name BumpTimings
extends Node2D

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var bump_to_str = {
	Globals.BUMP.TOO_FAR: "TOO FAR",
	Globals.BUMP.EARLY: "EARLY",
	Globals.BUMP.LATE: "LATE",
	Globals.BUMP.PERFECT: "PERFECT"
}

var type = Globals.BUMP.EARLY


func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	label.text = bump_to_str[type]
	appear()


func appear() -> void:
	visible = true
	timer.start()


func disappear() -> void:
	visible = false


func on_timer_timeout():
	disappear()
