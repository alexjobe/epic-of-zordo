extends KinematicBody2D

onready var player = get_node("../Player")

func _physics_process(delta):
	if position.distance_to(player.position) < 30:
		$SpeechBox.show()
	else:
		$SpeechBox.hide()

