extends Area2D

onready var player = get_node("../Player")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


func _on_body_entered(body):
	if body == player:
		if(Global.quest_stage == 1):
			Global.quest_stage = 2
			queue_free()
