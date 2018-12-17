# Global.gd
extends Node

var player_max_health = 16;
var player_health = 16;

func _ready():
	player_health = player_max_health
	
	# Maximum health should always be a multiple of 4, because a heart has 4 stages
	player_max_health = player_max_health - player_max_health % 4
