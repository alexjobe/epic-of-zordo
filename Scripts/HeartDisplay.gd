# HeartDisplay.gd
extends HBoxContainer

var Heart = preload("res://Scenes/UI/Heart.tscn")

var max_health = 4 setget set_max_health

func _ready():
	update_health(max_health)
	
func set_max_health(new_max_health):
	max_health = new_max_health

func update_health(health):
	var full_hearts = health / 4
	var partial = health % 4
	var empty_hearts = (max_health - health) / 4
	
	for child in get_children():
		child.queue_free()
	
	for i in range(full_hearts):
		var heart = Heart.instance()
		add_child(heart)
			
	if partial > 0:
		var heart = Heart.instance()
		add_child(heart)
		heart.set_filled(partial)
		
	for i in range(empty_hearts):
		var heart = Heart.instance()
		add_child(heart)
		heart.set_filled(0)