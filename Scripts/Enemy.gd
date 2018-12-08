# Enemy.gd
extends KinematicBody2D

enum Facing {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 20
export var facing = Facing.FORWARD
var velocity = Vector2()
var is_attacking = false
var is_pathing = false
var health = 3

func _physics_process(delta):
	process_movement(delta)
	
func process_movement(delta):
	
	if not is_attacking:
		random_path()
	
	walk_animation()
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	else:
		idle()
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2(0.0, 0.0)
	
func idle():
	if facing == Facing.RIGHT:
		$AnimatedSprite.animation = "Idle Right"
	if facing == Facing.LEFT:
		$AnimatedSprite.animation = "Idle Left"
	if facing == Facing.FORWARD:
		$AnimatedSprite.animation = "Idle Forward"
	if facing == Facing.BACKWARD:
		$AnimatedSprite.animation = "Idle Backward"

func walk_animation():
	if velocity.x > 0:
		$AnimatedSprite.animation = "Walk Right"
	elif velocity.y > 0:
		$AnimatedSprite.animation = "Walk Forward"
	elif velocity.x < 0:
		$AnimatedSprite.animation = "Walk Left"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "Walk Backward"
		
func random_path():
	if not is_pathing:
		is_pathing = true
		facing = randi() % 4
		velocity = Vector2(0.0, 0.0)
		
		random_movement()
		
		$"Path Timer".start()
		yield($"Path Timer", "timeout")
		is_pathing = false
		
func random_movement():
	if facing == Facing.RIGHT:
		velocity.x += randi() % 2
	elif facing == Facing.LEFT:
		velocity.x -= randi() % 2
	elif facing == Facing.FORWARD:
		velocity.y += randi() % 2
	elif facing == Facing.BACKWARD:
		velocity.y -= randi() % 2

func take_damage():
	health -= 1