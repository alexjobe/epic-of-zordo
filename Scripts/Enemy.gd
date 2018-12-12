# Enemy.gd
extends KinematicBody2D

var sprite = null
var path_timer = null
var stun_timer = null
var player = null
var nav = null

enum STATES {IDLE, WALK, ATTACK, STUN, DEATH}
enum FACING {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 20
export (int) var max_health = 3
export (int) var attack_range = 150

var current_state = null
var facing = FORWARD
var velocity = Vector2()
var health = null
var path = []

func _ready():
	sprite = $AnimatedSprite
	path_timer = $PathTimer
	stun_timer = $StunTimer
	player = get_node("../Player")
	nav = get_node("../Navigation2D")
	
	health = max_health
	
	_change_state(IDLE)
	
func _physics_process(delta):

	if not current_state == DEATH:
		process_movement(delta)
	
func _change_state(new_state):
	current_state = new_state

	match new_state:
		IDLE:
			set_animation("Idle")
			reset_velocity()
		WALK:
			set_animation("Walk")
		STUN:
			set_animation("Idle")
			stun_timer.start()
			yield(stun_timer, "timeout")
			_change_state(IDLE)
		DEATH:
			sprite.play("Death")
			yield(sprite, "animation_finished")
			queue_free()
	
func process_movement(delta):
	
	if not current_state == STUN:
		if position.distance_to(player.position) <= attack_range:
			_change_state(ATTACK)
	
	if current_state == IDLE:
		random_path()
	
	if current_state == ATTACK:
		if position.distance_to(player.position) > attack_range:
			_change_state(IDLE)
		else:
			path_to_player()
		
	move(delta)
				
func move(delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		var collision = move_and_collide(velocity * delta)
		if collision:
			if not collision.collider == player:
				_change_state(IDLE)
	
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
		
func random_path():
	if path_timer.is_stopped():
		facing = randi() % 4
		_change_state(WALK)
		reset_velocity()
		
		random_velocity()
		
		path_timer.start()
		yield(path_timer, "timeout")
		_change_state(IDLE)
		
func random_velocity():
	if facing == RIGHT:
		velocity.x += randi() % 2
	elif facing == LEFT:
		velocity.x -= randi() % 2
	elif facing == FORWARD:
		velocity.y += randi() % 2
	elif facing == BACKWARD:
		velocity.y -= randi() % 2
		
	if velocity.length() <= 0:
		_change_state(IDLE)
		
func set_facing():
	if abs(velocity.y) >= abs(velocity.x):
		if velocity.y > 0:
			facing = FORWARD
		elif velocity.y < 0:
			facing = BACKWARD
	elif velocity.x > 0:
		facing = RIGHT
	elif velocity.x < 0:
		facing = LEFT
	else:
		facing = FORWARD
		
func path_to_player():
	
	reset_velocity()
	path = nav.get_simple_path(position, player.position)
	velocity += (path[1] - position)
	set_facing()
	set_animation("Walk")

func take_damage():
	health -= 1
	reset_velocity()
	velocity += (position - player.position)
	
	if health <= 0:
		_change_state(DEATH)
	else:
		_change_state(STUN)
	
func reset_velocity():
	velocity = Vector2(0.0, 0.0)

