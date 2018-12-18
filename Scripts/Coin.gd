# Coin.gd
extends Area2D

onready var player = get_node("../Player")

func _ready():
	if Global.coin_found:
		queue_free()

func _on_body_entered(body):
	if body == player:
		Global.coin_found = true
		queue_free()
