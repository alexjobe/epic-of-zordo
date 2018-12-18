extends KinematicBody2D

onready var player = get_node("../Player")
onready var speech_box = $SpeechBox
onready var quest = $Quest
export var min_interact_distance = 30

func _physics_process(delta):
		
	if position.distance_to(player.position) > min_interact_distance:
		speech_box.hide()
	elif (position.distance_to(player.position) < min_interact_distance 
	and Global.quest_stage == 0):
		speech_box.show()

func _on_Player_interact():
	if position.distance_to(player.position) < min_interact_distance:
		if Global.quest_stage == 0:
			quest.set_stage(1)
		elif Global.quest_stage == 1 and Global.coin_found:
			quest.set_stage(2)
			
		speech_box.show()
