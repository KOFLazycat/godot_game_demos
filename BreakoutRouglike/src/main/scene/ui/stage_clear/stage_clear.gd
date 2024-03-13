extends Control

@onready var time: Label = $VB/HB/VBValue/Time
@onready var early_bumps: Label = $VB/HB/VBValue/EarlyBumps
@onready var late_bumps: Label = $VB/HB/VBValue/LateBumps
@onready var perfect_bumps: Label = $VB/HB/VBValue/PerfectBumps
@onready var bounces: Label = $VB/HB/VBValue/Bounces
@onready var score: Label = $VB/HB/VBValue/Score
@onready var final_score: Label = $VB/HB2/FinalScore
@onready var next_btn: Button = $VB2/NextBtn

var bump_earlylate_multiplicator: int = 500
var bump_perfect_multiplicator: int = 2000
var bounce_multiplicator: int = 10

signal next


func _ready() -> void:
	next_btn.pressed.connect(on_next_btn_pressed)
	next_btn.grab_focus()
	update_stats()


func update_stats() -> void:
	var ms = Globals.stats["time"] * 1000
	var seconds: int = int(ms / 1000 )% 60
	var minutes: int = int(ms / 1000 / 60)
	time.text = str(minutes) + ":" + str(seconds)
	early_bumps.text = str(Globals.stats["bumps_early"])
	late_bumps.text = str(Globals.stats["bumps_late"])
	perfect_bumps.text = str(Globals.stats["bumps_perfect"])
	bounces.text = str(Globals.stats["ball_bounces"])
	score.text = str(Globals.stats["score"])
	final_score.text = str((Globals.stats["bumps_early"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_late"]*bump_earlylate_multiplicator)+
		(Globals.stats["bumps_perfect"]*bump_perfect_multiplicator)+
		(Globals.stats["ball_bounces"]*bounce_multiplicator)+
		Globals.stats["score"])


func on_next_btn_pressed() -> void:
	emit_signal("next")
	queue_free()
