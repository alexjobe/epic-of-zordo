# Player.gd
extends KinematicBody2D

signal attack_front
signal attack_back
signal attack_right
signal attack_left

var sprite = null

enum STATES {IDLE, WALK, ATTACK}
enum FACING {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 100
export (int) var max_health = 5
export (Color) var damage_tint = Color(1, 0, 0)

var current_state = null
var facing = FORWARD
var velocity = Vector2()
var health

func _ready():
	
	sprite = $AnimatedSprite
	
	health = max_health
	
	_change_state(IDLE)

func _physics_process(delta):
	if current_state == IDLE or current_state == WALK:
		get_input()
		process_movement(delta)
	
	
func _change_state(new_state):
	current_state = new_state

	match new_state:
		IDLE:
			set_animation("Idle")
			reset_velocity()
		ATTACK:
			set_animation("Attack")
			reset_velocity()
		WALK:
			set_animation("Walk")

func get_input():
	
	reset_velocity()
	
	if Input.is_action_just_pressed("ui_attack"):
		attack()
		return
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		facing = RIGHT
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		facing = LEFT
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		facing = FORWARD
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		facing = BACKWARD
				
func process_movement(delta):
	
	if current_state == ATTACK:
		return
		
	if velocity.length() > 0:
		_change_state(WALK)
		velocity = velocity.normalized() * speed
	else:
		_change_state(IDLE)
		return
		
	var collision = move_and_collide(velocity * delta)
			
func attack():
	_change_state(ATTACK)
	
	match facing:
		FORWARD:
			emit_signal("attack_front")
		BACKWARD:
			emit_signal("attack_back")
		RIGHT:
			emit_signal("attack_right")
		LEFT:
			emit_signal("attack_left")
	
	# Wait for attack animation to finish, then switch to idle
	yield(sprite, "animation_finished")
	_change_state(IDLE)
	
func take_damage():
	health -= 1
	sprite.modulate = damage_tint
	yield(get_tree().create_timer(0.3), "timeout")
	sprite.modulate = Color(1, 1, 1)
	
func set_animation(type):
	
	match facing:
		RIGHT:
			sprite.animation = type + " Right"
		LEFT:
			sprite.animation = type + " Left"
		FORWARD:
			sprite.animation = type + " Forward"
		BACKWARD:
			sprite.animation = type + " Backward"
		
func reset_velocity():
	velocity = Vector2(0.0, 0.0)
	
