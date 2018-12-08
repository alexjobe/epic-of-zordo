# AttackZone.gd
extends Area2D

enum States {IDLE, ATTACK}
var current_state = IDLE
var already_hit = []

func _ready():
	_change_state(IDLE)
	
func attack():
	_change_state(ATTACK)

func end_attack():
	_change_state(IDLE)

func _change_state(new_state):
	current_state = new_state
	
	match current_state:
		IDLE:
			monitoring = false
		ATTACK:
			already_hit = []
			monitoring = true
			
func _physics_process(delta):
	
	if current_state == ATTACK:
		var overlapping_bodies = get_overlapping_bodies()
		
		if not overlapping_bodies:
			return
		
		for body in overlapping_bodies:
			if body.is_in_group("Enemies") and not already_hit.has(body):
				body.take_damage()
				already_hit.append(body)
			else:
				return
		
		
		