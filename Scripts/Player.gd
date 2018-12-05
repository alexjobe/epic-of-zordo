extends KinematicBody2D

export (int) var speed = 150
var velocity = Vector2()

func get_input():
		
	velocity = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
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
		if $AnimatedSprite.animation == "Walk Right":
			$AnimatedSprite.animation = "Idle Right"
		if $AnimatedSprite.animation == "Walk Left":
			$AnimatedSprite.animation = "Idle Left"
		if $AnimatedSprite.animation == "Walk Forward":
			$AnimatedSprite.animation = "Idle Forward"
		if $AnimatedSprite.animation == "Walk Backward":
			$AnimatedSprite.animation = "Idle Backward"

func _process(delta):
	get_input()
	position += velocity * delta
	
