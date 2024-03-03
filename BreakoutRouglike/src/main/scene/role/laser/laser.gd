extends Area2D

@onready var laser: Area2D = $"."
@onready var charge_timer: Timer = $ChargeTimer
@onready var attack_timer: Timer = $AttackTimer

var attacking: bool = false

func _ready() -> void:
	visible = false
	laser.body_entered.connect(on_laser_body_entered)
	charge_timer.timeout.connect(on_charge_timer_timeout)
	attack_timer.timeout.connect(on_attack_timer_timeout)
	
func _show() -> void:
	visible = true
	
func _hide() -> void:
	visible = false

func shoot() -> void:
	_show()
	attack_timer.start()
	attacking = true
	# Damage bricks that are already inside the area when we 
	# start attacking
	for body in get_overlapping_bodies():
		body.damage(100)


func on_charge_timer_timeout() -> void:
	pass


func on_attack_timer_timeout() -> void:
	_hide()
	attacking = false

func on_laser_body_entered(body: Node2D) -> void:
	if not attacking: 
		return
	if body.is_in_group("Bricks"):
		body.damage(100)
