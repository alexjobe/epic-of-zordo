# HeartDisplay.gd
extends HBoxContainer

var Heart = preload("res://Scenes/UI/Heart.tscn")

var max_health = 4 setget set_max_health
var hearts = []

func _ready():
	set_max_health(max_health)
	
# Called when the player's maximum health changes
# (e.g., When the player finds a heart container)
func set_max_health(new_max_health):
	max_health = new_max_health
	var num_hearts = max_health / 4
	hearts = []
	
	for child in get_children():
		child.queue_free()
	
	for i in range(num_hearts):
		var heart = Heart.instance()
		add_child(heart)
		hearts.append(heart)

# Called when the player's current health changes
# (e.g., When the player takes damage)
func update_health(new_health):
	# Health cannot be negative
	var health = max(0, new_health)
	var full_hearts = health / 4
	# The value of the partial heart. For example, a value of 3 means
	# the partial heart is 3/4 full, while a value of 1 means it is 1/4 full
	var partial = health % 4
	# How many empty hearts to display
	var empty_hearts = (max_health - health) / 4

	for i in range(full_hearts):
		hearts[i].set_filled(4)
			
	if partial > 0:
		hearts[full_hearts].set_filled(partial)
	
	if empty_hearts <= hearts.size() and empty_hearts > 0:
		# If there is no partial, we do not display it
		var is_partial = false
		if partial:
			is_partial = true
		for i in range(full_hearts + int(is_partial), hearts.size()):
			hearts[i].set_filled(0)