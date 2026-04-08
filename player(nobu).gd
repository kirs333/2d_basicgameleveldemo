extends CharacterBody2D

const SPEED = 120

@onready var anim = $AnimatedSprite2D

var last_direction = "down"
var is_attacking = false

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Movement input
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	direction = direction.normalized()

	# Stop movement while attacking (optional but recommended)
	if not is_attacking:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Attack input
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	# Animation (only if NOT attacking)
	if not is_attacking:
		if direction != Vector2.ZERO:
			if abs(direction.x) > abs(direction.y):
				if direction.x > 0:
					anim.play("walk_right")
					last_direction = "right"
				else:
					anim.play("walk_left")
					last_direction = "left"
			else:
				if direction.y > 0:
					anim.play("walk_down")
					last_direction = "down"
				else:
					anim.play("walk_up")
					last_direction = "up"
		else:
			anim.stop()

# Attack function
func attack():
	is_attacking = true

	anim.play("attack_" + last_direction)

	await anim.animation_finished

	is_attacking = false
