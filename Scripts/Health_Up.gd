# Health_Up.gd
extends Area2D

onready var player = get_node("../Player")
onready var hearts = get_node("../CanvasLayer/Interface/MarginContainer/HeartDisplay")

func _on_body_entered(body):
	if body == player:
		Global.player_health = min(Global.player_max_health, Global.player_health + 4)
		
	hearts.update_health(Global.player_health)
	queue_free()