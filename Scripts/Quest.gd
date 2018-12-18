extends Node

var quest_id = 0
enum PROGRESS {START, IN_PROGRESS, COMPLETED}

export (PROGRESS) var progress = START

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
