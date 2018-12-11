# Enemy.gd
extends KinematicBody2D

var sprite = null
var path_timer = null
var player = null
var nav = null

enum STATES {IDLE, WALK, ATTACK}
enum FACING {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 20
export (int) var max_health = 3
export (int) var attack_range = 150

var current_state = null
var facing = FORWARD
var velocity = Vector2()
var health
var path = []

func _ready():
	sprite = $AnimatedSprite
	path_timer = $PathTimer
	player = get_node("../Player")
	nav = get_node("../Navigation2D")
	
	health = max_health
	
	_change_state(IDLE)
	
func _physics_process(delta):

	process_movement(delta)
	
func _change_state(new_state):
	current_state = new_state

	match new_state:
		IDLE:
			idle_animation()
			velocity = Vector2(0.0, 0.0)
		WALK:
			walk_animation()
	
func process_movement(delta):
	
	if position.distance_to(player.position) <= attack_range:
		_change_state(ATTACK)
	
	if current_state == IDLE:
		random_path()
	
	if current_state == ATTACK:
		if position.distance_to(player.position) > attack_range:
			_change_state(IDLE)
		else:
			move_towards_player()
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		_change_state(IDLE)
		return
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		_change_state(IDLE)
	
func idle_animation():
	if facing == RIGHT:
		sprite.animation = "Idle Right"
	elif facing == LEFT:
		sprite.animation = "Idle Left"
	elif facing == FORWARD:
		sprite.animation = "Idle Forward"
	elif facing == BACKWARD:
		sprite.animation = "Idle Backward"
		
func walk_animation():
	if facing == RIGHT:
		sprite.animation = "Walk Right"
	elif facing == LEFT:
		sprite.animation = "Walk Left"
	elif facing == FORWARD:
		sprite.animation = "Walk Forward"
	elif facing == BACKWARD:
		sprite.animation = "Walk Backward"
		
func random_path():
	if path_timer.is_stopped():
		facing = randi() % 4
		_change_state(WALK)
		velocity = Vector2(0.0, 0.0)
		
		random_movement()
		
		path_timer.start()
		yield(path_timer, "timeout")
		_change_state(IDLE)
		
func random_movement():
	if facing == RIGHT:
		velocity.x += randi() % 2
	elif facing == LEFT:
		velocity.x -= randi() % 2
	elif facing == FORWARD:
		velocity.y += randi() % 2
	elif facing == BACKWARD:
		velocity.y -= randi() % 2
		
func set_facing():
	if abs(velocity.y) >= abs(velocity.x):
		if velocity.y > 0:
			facing = FORWARD
		elif velocity.y < 0:
			facing = BACKWARD
	else:
		if velocity.x > 0:
			facing = RIGHT
		elif velocity.x < 0:
			facing = LEFT
		else:
			facing = FORWARD
		
func move_towards_player():
	
	velocity = Vector2(0.0, 0.0)
	path = nav.get_simple_path(position, player.position)
	velocity += (path[1] - position)
	set_facing()
	walk_animation()

func take_damage():
	health -= 1