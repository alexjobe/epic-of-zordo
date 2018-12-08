# Player.gd
extends KinematicBody2D

signal begin_attack
signal end_attack

var sprite = null

enum STATES {IDLE, WALK, ATTACK}
enum FACING {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 100
export (int) var max_health = 5

var current_state = null
var facing = FORWARD
var velocity = Vector2()
var health

func _ready():
	connect("begin_attack", $AttackZone, "attack")
	connect("end_attack", $AttackZone, "end_attack")
	
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
			idle_animation()
			velocity = Vector2(0.0, 0.0)
		ATTACK:
			attack_animation()
			velocity = Vector2(0.0, 0.0)
		WALK:
			walk_animation()

func get_input():
	
	velocity = Vector2(0.0, 0.0)
	
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
	
	emit_signal("begin_attack")
		
	yield(sprite, "animation_finished")
	_change_state(IDLE)
	
	emit_signal("end_attack")
	
func idle_animation():
	if facing == RIGHT:
		sprite.animation = "Idle Right"
	if facing == LEFT:
		sprite.animation = "Idle Left"
	if facing == FORWARD:
		sprite.animation = "Idle Forward"
	if facing == BACKWARD:
		sprite.animation = "Idle Backward"
		
func walk_animation():
	if velocity.x > 0:
		sprite.animation = "Walk Right"
	elif velocity.y > 0:
		sprite.animation = "Walk Forward"
	elif velocity.x < 0:
		sprite.animation = "Walk Left"
	elif velocity.y < 0:
		sprite.animation = "Walk Backward"
		
func attack_animation():
	if facing == RIGHT:
		sprite.play("Attack Right")
	elif facing == LEFT:
		sprite.play("Attack Left")
	elif facing == FORWARD:
		sprite.play("Attack Forward")
	elif facing == BACKWARD:
		sprite.play("Attack Backward")
	
