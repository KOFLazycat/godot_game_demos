extends Node

signal dead()
signal enter_water()
signal exit_water()
signal shooting(bullet_poistion: Vector2, bulet_direction : Vector2)
signal stop_shooting()
signal receive_damages_from_player(damage: int)
signal respawn_turret(position: Vector2)
