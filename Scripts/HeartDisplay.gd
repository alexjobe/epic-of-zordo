# HeartDisplay.gd
extends HBoxContainer

var Heart = preload("res://Scenes/UI/Heart.tscn")

var max_health = 4 setget set_max_health

func _ready():
	set_max_health(max_health)
	
# Called when the player's maximum health changes
# (e.g., When the player finds a heart container)
func set_max_health(new_max_health):
	max_health = new_max_health
	var num_hearts = max_health / 4
	
	for child in get_children():
		child.queue_free()
	
	for i in range(num_hearts):
		var heart = Heart.instance()
		add_child(heart)

# Called when the player's current health changes
# (e.g., When the player takes damage)
func update_health(health):
	health = max(0, health)
	var full_hearts = health / 4
	var partial = health % 4
	var empty_hearts = (max_health - health) / 4
	
	var hearts = get_children()
	
	for i in range(full_hearts):
		hearts[i].set_filled(4)
			
	if partial > 0:
		hearts[full_hearts].set_filled(partial)
	
	if empty_hearts <= hearts.size():
		for i in range(full_hearts + partial, hearts.size()):
			hearts[i].set_filled(0)