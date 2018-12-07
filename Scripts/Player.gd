# Player.gd
extends KinematicBody2D

enum Facing {FORWARD, BACKWARD, RIGHT, LEFT}

export (int) var speed = 100
var velocity = Vector2()
var facing = Facing.FORWARD
var is_attacking = false

func _physics_process(delta):
	get_input()
	process_movement(delta)

func get_input():
	
	velocity = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		facing = Facing.RIGHT
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		facing = Facing.LEFT
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
		facing = Facing.FORWARD
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		facing = Facing.BACKWARD
		
	if Input.is_action_just_pressed("ui_attack"):
		attack()
				
func process_movement(delta):
	
	if not is_attacking:
		if velocity.x > 0:
			$AnimatedSprite.animation = "Walk Right"
		elif velocity.y > 0:
			$AnimatedSprite.animation = "Walk Forward"
		elif velocity.x < 0:
			$AnimatedSprite.animation = "Walk Left"
		elif velocity.y < 0:
			$AnimatedSprite.animation = "Walk Backward"
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		else:
			idle()
			
		var collision = move_and_collide(velocity * delta)
			
			
func idle():
	if facing == Facing.RIGHT:
		$AnimatedSprite.animation = "Idle Right"
	if facing == Facing.LEFT:
		$AnimatedSprite.animation = "Idle Left"
	if facing == Facing.FORWARD:
		$AnimatedSprite.animation = "Idle Forward"
	if facing == Facing.BACKWARD:
		$AnimatedSprite.animation = "Idle Backward"
			
func attack():
	velocity = Vector2(0.0, 0.0)
	
	if facing == Facing.RIGHT:
		$AnimatedSprite.play("Attack Right")
	elif facing == Facing.LEFT:
		$AnimatedSprite.play("Attack Left")
	elif facing == Facing.FORWARD:
		$AnimatedSprite.play("Attack Forward")
	elif facing == Facing.BACKWARD:
		$AnimatedSprite.play("Attack Backward")
		
	is_attacking = true
	yield($AnimatedSprite, "animation_finished")
	is_attacking = false
	
